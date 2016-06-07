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

# Use ClusterSearch
::Chef::Recipe.send(:include, ClusterSearch)

# Looking for members of Imply cluster
node.run_state['imply_cluster'] = cluster_search(node['imply-platform'])
return if node.run_state['imply_cluster'].nil?

# Looking for members of ZooKeeper cluster
zookeeper = cluster_search(node['imply-platform']['zookeeper'])
return if zookeeper.nil? # Not enough nodes
zk = zookeeper['hosts'].map do |host|
  "#{host}:2181"
end.join(',')

# Using members of MariaDB Galera cluster
mariadb_hosts =
  node.run_state['imply-platform']['metadata_servers']

db = node.run_state['imply-platform']['metadata_db']

# Get common properties and define master Zookeeper address
# and jdbc url
common_runtime_properties = druid_config['common_runtime_properties'].to_hash
common_runtime_properties['druid.zk.service.host'] = zk
common_runtime_properties['druid.metadata.storage.connector.connectURI'] =
  "jdbc:mysql://#{mariadb_hosts}/#{db}?failOverReadOnly=false"

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
