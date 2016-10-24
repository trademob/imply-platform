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

imply_home = node['imply-platform']['prefix_home']
druid_config_path = "#{imply_home}/imply/conf/druid"

# Change in these config files will trigger a role daemon restart
components_per_role = node['imply-platform']['components_per_role']

config_files = components_per_role.values.flatten.map do |component|
  specifics = %w(jvm.config runtime.properties).map do |file|
    "template[#{druid_config_path}/#{component}/#{file}]"
  end
  commons = %w(common.runtime.properties log4j2.xml).map do |common|
    "template[#{druid_config_path}/_common/#{common}"
  end
  [component, specifics + commons]
end.to_h
config_files['pivot'] =
  ["template[#{imply_home}/imply/conf/pivot/config.yaml]"]

# Determine role to start from node id in cluster
%w(master data query client).each do |role|
  # Install only service we need
  imply_role = node.run_state['imply-platform'][role]
  next unless imply_role && imply_role.include?(node['fqdn'])

  # Auto restart service if change in a template file
  auto_restart = node['imply-platform']['auto_restart']

  components_per_role[role].each do |service|
    service_name = "imply-druid-#{service}"
    service_name = "imply-#{service}" if service == 'pivot'

    service service_name do
      action [:enable, :start]
      subscribes :restart, config_files[service] if auto_restart
    end
  end
end
