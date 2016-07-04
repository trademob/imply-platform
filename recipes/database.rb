#
# Copyright (c) 2016 Sam4Mobile
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

druid_config = node['imply-platform']['druid']['config']
common_properties = druid_config['common_runtime_properties']

database_type = common_properties['druid.metadata.storage.type']

# Metadata credentials
# Load password from encrypted data bag
data_bag = node['imply-platform']['data_bag']
node.run_state['imply-platform']['metadata_password'] =
  data_bag_item(data_bag['name'], data_bag['item'])[data_bag['key']]

# Default to 'druid' database
db = node['imply-platform']['metadata']['database']

case database_type
when 'postgresql'
  # Use community cookbook for managing postgresql database creation
  include_recipe "database::#{database_type}"

  connection_parameters = {
    host: node.run_state['imply-platform']['metadata_first_server'],
    port: node['imply-platform']['metadata']['server']['port'],
    username: node['imply-platform']['metadata']['user']['login'],
    password: node.run_state['imply-platform']['metadata_password']
  }

  postgresql_database db do
    connection connection_parameters
    action :create
  end
when 'mysql'
  host = node.run_state['imply-platform']['metadata_first_server']

  execute 'create druid database on backend' do
    command <<-EOF
      mysql -h #{host} \
      -u #{node['imply-platform']['metadata']['user']['login']} \
      -p'#{node.run_state['imply-platform']['metadata_password']}' \
      -e "CREATE DATABASE IF NOT EXISTS #{db} \
      DEFAULT CHARACTER SET = UTF8 \
      COLLATE = 'utf8_general_ci';"
    EOF
  end

else
  raise 'The database type provided cannot be handled'
end
