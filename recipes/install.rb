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

package_retries = node[cookbook_name]['package_retries']

# tar may not be installed by default
package 'tar' do
  retries package_retries unless package_retries.nil?
end

# Create prefix directories
[
  node[cookbook_name]['prefix_root'],
  node[cookbook_name]['prefix_home'],
  node[cookbook_name]['prefix_bin']
].uniq.each do |dir_path|
  directory "imply-platform:#{dir_path}" do
    path dir_path
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
  end
end

# var, tmp and log dir owned by imply user
dirs = []
dirs << node[cookbook_name]['var_dir']
tmp = node[cookbook_name]['tmp_dir']
dirs << tmp
components_per_role = node[cookbook_name]['components_per_role']
dirs += components_per_role.values.flatten.uniq.map { |c| "#{tmp}/#{c}" }
dirs << node[cookbook_name]['log_dir']

dirs.each do |dir|
  directory dir do
    owner node[cookbook_name]['user']
    group node[cookbook_name]['group']
    recursive true
    action :create
  end
end

ark 'imply' do
  action :install
  url node[cookbook_name]['mirror']
  prefix_root node[cookbook_name]['prefix_root']
  prefix_home node[cookbook_name]['prefix_home']
  prefix_bin node[cookbook_name]['prefix_bin']
  strip_components 2
  has_binaries []
  checksum node[cookbook_name]['checksum']
  version node[cookbook_name]['version']
  notifies :run, 'execute[imply-platform:save_default_config]', :immediately
end

imply_home = "#{node[cookbook_name]['prefix_home']}/imply"
execute 'imply-platform:save_default_config' do
  command "cp -r #{imply_home}/conf #{imply_home}/conf.default"
  creates "#{imply_home}/conf.default"
  action :nothing
end

# Java packages are needed by imply, can install it with package
java_package = node[cookbook_name]['java'][node['platform']]
package java_package do
  retries package_retries unless package_retries.nil?
  not_if java_package.to_s.empty?
end
