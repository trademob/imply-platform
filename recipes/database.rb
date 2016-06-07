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
node.run_state['imply-platform'] = {}
data_bag = node['imply-platform']['data_bag']
node.run_state['imply-platform']['metadata_password'] =
  data_bag_item(
    data_bag['name'],
    data_bag['item']
  )[data_bag['key']]

include_recipe "database::#{database_type}" if database_type == 'postgresql'

connection_parameters = {
  host: node['imply-platform']['metadata']['server']['host'],
  port: node['imply-platform']['metadata']['server']['port'],
  username: node['imply-platform']['metadata']['user']['login'],
  password: node.run_state['imply-platform']['metadata_password']
}

# Default to 'druid' database
db = node['imply-platform']['metadata']['database']

case database_type
when 'postgresql'
  postgresql_database db do
    connection(
      connection_parameters
    )
    action :create
  end
when 'mysql'
  # Looking for members of MariaDB Galera cluster
  mariadb = cluster_search(node['imply-platform']['mariadb'])
  return if mariadb.nil? # Not enough nodes
  node.run_state['imply-platform']['metadata_db'] = db
  node.run_state['imply-platform']['metadata_servers'] =
    mariadb['hosts'].map do |host|
      host
    end.join(',')

  # Dependencies needed for mysql2 gem installation
  %w(gcc make ruby-devel MariaDB-devel rubygems).each do |pkg|
    package pkg do
      action :install
    end
  end

  # mysql2 gem is needed to interact with mariadb server
  chef_gem 'mysql2' do
    compile_time false
  end

  connection_parameters = connection_parameters.to_h
  connection_parameters['host'] =
    node.run_state['imply-platform']['metadata_servers'][0]

  # Create druid database on mysql backend
  mysql_database db do
    connection(
      connection_parameters
    )
    encoding 'utf8'
    action :create
  end
else
  raise 'The database type provided cannot be handled'
end
