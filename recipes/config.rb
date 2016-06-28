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

# Generate config
imply_home = node['imply-platform']['prefix_home']
druid_config = node['imply-platform']['druid']['config']
druid_config_path = "#{imply_home}/imply/conf/druid"

unless node.run_state['imply-platform']['metadata_servers'].nil?
  # Using members of MariaDB Galera cluster
  mariadb_hosts = node.run_state['imply-platform']['metadata_servers']
end
# Using single backend db host if not in cluster mode
mariadb_hosts =
  node['imply-platform']['metadata']['server']['host'] if mariadb_hosts.nil?

# Set the database to create
db = node['imply-platform']['metadata']['database']

# Get common properties and define master Zookeeper address
# and jdbc url
common_runtime_properties = druid_config['common_runtime_properties'].to_hash
common_runtime_properties['druid.zk.service.host'] =
  node.run_state['imply-platform']['zookeeper']

# Construct the jdbc url to use with failover support
common_runtime_properties['druid.metadata.storage.connector.connectURI'] =
  "jdbc:mysql://#{mariadb_hosts}/#{db}?failOverReadOnly=false"

# Define the password to use to connect to the database
common_runtime_properties['druid.metadata.storage.connector.password'] =
  node.run_state['imply-platform']['metadata_password']

# Druid common properties
druid_config_common = druid_config['common_runtime_properties']
template "#{druid_config_path}/_common/common.runtime.properties" do
  variables config: common_runtime_properties
  mode '0640'
  source 'druid/common.runtime.properties.erb'
end

# Druid jvm properties
druid_config_jvm = druid_config['jvm']
%w(broker coordinator historical middleManager overlord).each do |component|
  template "#{druid_config_path}/#{component}/jvm.config" do
    variables config: druid_config_jvm[component]
    mode '0640'
    source 'druid/jvm.config.erb'
  end
end

# Druid components properties
druid_config_components = druid_config['components']
%w(broker coordinator historical middleManager overlord).each do |component|
  template "#{druid_config_path}/#{component}/runtime.properties" do
    variables config: druid_config_components[component]
    mode '0640'
    source 'druid/runtime.properties.erb'
  end
end

# Create default indexer logs and storage directories if storage is local
if druid_config_common['druid.storage.type'] == 'local'
  %w(druid.indexer.logs.directory druid.storage.storageDirectory).each do |dir|
    directory druid_config_common[dir] do
      user node['imply-platform']['user']
      group node['imply-platform']['group']
      recursive true
    end
  end
end
