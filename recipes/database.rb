#
# Copyright (c) 2016-2017 Sam4Mobile, 2018 Make.org
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

druid_config = node[cookbook_name]['druid']['config']
common_properties = druid_config['common_runtime_properties']

database_type = common_properties['druid.metadata.storage.type']

# Metadata credentials
# Load password from encrypted data bag
data_bag = node[cookbook_name]['data_bag']
node.run_state[cookbook_name]['metadata_password'] =
  data_bag_item(data_bag['name'], data_bag['item'])[data_bag['key']]

# Default to 'druid' database
db = node[cookbook_name]['metadata']['database']

host = node.run_state[cookbook_name]['metadata_first_server']
port = node[cookbook_name]['metadata']['server']['port']
login = node[cookbook_name]['metadata']['user']['login']
password = node.run_state[cookbook_name]['metadata_password']

case database_type
when 'postgresql'
  # Use community cookbook for managing postgresql database creation
  include_recipe "database::#{database_type}"

  connection_parameters = {
    host: host,
    port: port,
    username: login,
    password: password
  }

  postgresql_database db do
    connection connection_parameters
    action :create
  end
when 'mysql'
  # Install mysql command
  mysql_package = node[cookbook_name]['mysql'][node['platform']]
  package_retries = node[cookbook_name]['package_retries']

  package mysql_package do
    retries package_retries unless package_retries.nil?
    not_if { mysql_package.to_s.empty? }
  end
  execute 'create druid database on backend' do
    command <<-MYSQL
      mysql -h #{host} --port #{port} \
      -u #{node[cookbook_name]['metadata']['user']['login']} \
      -p'#{node.run_state[cookbook_name]['metadata_password']}' \
      -e "CREATE DATABASE IF NOT EXISTS #{db} \
      DEFAULT CHARACTER SET = UTF8 \
      COLLATE = 'utf8_general_ci';"
    MYSQL
    retries node[cookbook_name]['database_creation_retries']
    retry_delay node[cookbook_name]['database_creation_retry_delay']
    not_if "mysql -h #{host} -u #{login} -p'#{password}' -e 'use #{db}'"
  end

else
  raise 'The database type provided cannot be handled'
end
