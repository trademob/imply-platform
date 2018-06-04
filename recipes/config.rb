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

# Generate config
imply_home = node[cookbook_name]['prefix_home']
config = node[cookbook_name]['druid']['config']
path = "#{imply_home}/imply/conf/druid"

unless node.run_state[cookbook_name]['metadata_servers'].nil?
  # Using members of DB cluster
  database_hosts = node.run_state[cookbook_name]['metadata_servers']
end

# Set the database to create
db = node[cookbook_name]['metadata']['database']

# Get common properties and define master Zookeeper address
# and jdbc url
common_runtime_properties = config['common_runtime_properties'].to_hash
common_runtime_properties['druid.zk.service.host'] =
  node.run_state[cookbook_name]['zookeeper']

# Construct the jdbc url to use with failover support
common_runtime_properties['druid.metadata.storage.connector.connectURI'] =
  "jdbc:mysql://#{database_hosts}/#{db}?failOverReadOnly=false"

# Define the password to use to connect to the database
common_runtime_properties['druid.metadata.storage.connector.password'] =
  node.run_state[cookbook_name]['metadata_password']

# Druid common properties
config_common = config['common_runtime_properties']
template "#{path}/_common/common.runtime.properties" do
  variables config: common_runtime_properties
  mode '0640'
  source 'druid/common.runtime.properties.erb'
  user node[cookbook_name]['user']
  group node[cookbook_name]['group']
end

# Druid jvm properties
config_jvm = config['jvm'].to_h
common = config_jvm['common']
%w[broker coordinator historical middleManager overlord].each do |component|
  conf = common.map { |k, v| [k, format(v, component: component)] }.to_h
  conf = conf.merge(config_jvm[component])
  template "#{path}/#{component}/jvm.config" do
    variables config: conf
    mode '0640'
    source 'druid/jvm.config.erb'
    user node[cookbook_name]['user']
    group node[cookbook_name]['group']
  end
end

# Druid components properties
config_components = config['components']
%w[broker coordinator historical middleManager overlord].each do |component|
  template "#{path}/#{component}/runtime.properties" do
    variables config: config_components[component]
    mode '0640'
    source 'druid/runtime.properties.erb'
    user node[cookbook_name]['user']
    group node[cookbook_name]['group']
  end
end

# Create default indexer logs and storage directories if storage is local
if config_common['druid.storage.type'] == 'local'
  %w[druid.indexer.logs.directory druid.storage.storageDirectory].each do |dir|
    directory config_common[dir] do
      user node[cookbook_name]['storage_dir']['user']
      group node[cookbook_name]['storage_dir']['group']
      mode node[cookbook_name]['storage_dir']['mode']
      recursive true
    end
  end
end

# Log4j2 config file
chef_gem 'xml-simple' do
  compile_time true
end

template "#{path}/_common/log4j2.xml" do
  variables config: config['log4j2']
  mode '0644'
  source 'xml.erb'
  user node[cookbook_name]['user']
  group node[cookbook_name]['group']
end

# Pivot yaml file
pivot_conf = config['components']['pivot'].to_hash
pivot_conf['initialSettings']['connections'] =
  pivot_conf['initialSettings']['connections'].map do |name, values|
    { 'name' => name }.merge(values)
  end
template "#{imply_home}/imply/conf/pivot/config.yaml" do
  variables config: pivot_conf
  mode '0644'
  source 'yaml.erb'
end
