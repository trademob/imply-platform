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

# Use ClusterSearch
::Chef::Recipe.send(:include, ClusterSearch)

node.run_state['imply-platform'] = {}

# Looking for members of ZooKeeper cluster
zookeepers = cluster_search(node['imply-platform']['zookeeper'])
return if zookeepers.nil? # Not enough nodes
node.run_state['imply-platform']['zookeeper'] =
  zookeepers['hosts'].map { |host| "#{host}:2181" }.join(',')

# Looking for members of MySQL/MariaDB cluster
mariadb = cluster_search(node['imply-platform']['mariadb'])
return if mariadb.nil? # Not enough nodes
node.run_state['imply-platform']['metadata_first_server'] = mariadb['hosts'][0]

node.run_state['imply-platform']['metadata_servers'] =
  mariadb['hosts'].join(',')

# Searching for nodes having the imply query role
imply_query = cluster_search(node['imply-platform']['query'])
return if imply_query.nil? # Not enough nodes

node.run_state['imply-platform']['query'] =
  imply_query['hosts'].include? node['fqdn']
