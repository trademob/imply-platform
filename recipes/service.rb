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

# Determine role to start from node id in cluster
%w(master data query).each do |role|
  role_ids = node['imply-platform'][role]['ids']

  role_in_cluster = nil
  unless node.run_state['imply_cluster'].nil?
    role_in_cluster =
      role_ids.include? node.run_state['imply_cluster']['my_id']
  end
  # Node should start the role if not part of a cluster and
  # attribute is defined
  if role_in_cluster.nil?
    role_standalone = node['imply-platform']['standalone']
  end

  auto_restart = node['imply-platform']['auto_restart']
  if auto_restart
    imply_home = node['imply-platform']['prefix_home']
    druid_config_path = "#{imply_home}/imply/conf/druid"
    config_files = [
      "#{druid_config_path}/_common/common.runtime.properties",
      "#{druid_config_path}/broker/jvm.config",
      "#{druid_config_path}/coordinator/jvm.config",
      "#{druid_config_path}/historical/jvm.config",
      "#{druid_config_path}/middleManager/jvm.config",
      "#{druid_config_path}/overlord/jvm.config"
    ].map do |path|
      "template[#{path}]"
    end
  else config_files = []
  end

  # Start roles
  service "imply-#{role}" do
    action [:enable, :start]
    subscribes :restart, config_files if auto_restart
    only_if { role_in_cluster || role_standalone }
  end
end
