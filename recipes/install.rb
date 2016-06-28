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

# tar may not be installed by default
package 'tar'

# Create prefix directories
[
  node['imply-platform']['prefix_root'],
  node['imply-platform']['prefix_home'],
  node['imply-platform']['prefix_bin']
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

ark 'imply' do
  action :install
  url node['imply-platform']['mirror']
  prefix_root node['imply-platform']['prefix_root']
  prefix_home node['imply-platform']['prefix_home']
  prefix_bin node['imply-platform']['prefix_bin']
  has_binaries []
  checksum node['imply-platform']['checksum']
  version node['imply-platform']['version']
  owner node['imply-platform']['user']
end

# Java packages are needed by imply, can install it with package
java_package = node['imply-platform']['java'][node['platform']]
package java_package unless java_package.to_s.empty?

# Perl package is needed by init scripts for imply daemons
package 'perl'
