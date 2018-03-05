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

# Use ClusterSearch
::Chef::Recipe.send(:include, ClusterSearch)

node.run_state[cookbook_name] ||= {}
node.run_state[cookbook_name]['my_roles'] = []

# Searching for nodes having the imply master/data/query/client role
%w[master data query client].each do |role|
  imply_role = cluster_search(node[cookbook_name][role])
  next unless imply_role
  node.run_state[cookbook_name][role] = imply_role['hosts']
  if imply_role['hosts'].include?(node['fqdn'])
    node.run_state[cookbook_name]['my_roles'] << role
  end
end

# Looking for members of ZooKeeper cluster
zookeepers = cluster_search(node[cookbook_name]['zookeeper'])
return if zookeepers.nil? # Not enough nodes
node.run_state[cookbook_name]['zookeeper'] =
  zookeepers['hosts'].map { |host| "#{host}:2181" }.join(',')

# Looking for members of MySQL or MariaDB cluster
database = cluster_search(node[cookbook_name]['database'])
return if database.nil? # Not enough nodes
node.run_state[cookbook_name]['metadata_first_server'] =
  database['hosts'].first

node.run_state[cookbook_name]['metadata_servers'] =
  database['hosts'].join(',')
