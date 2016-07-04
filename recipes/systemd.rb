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

# Deploy systemd unit files
unit_path = node['imply-platform']['unit_path']

%w(master data query).each do |role|
  # Deploy template if node has role
  imply_role = node.run_state['imply-platform'][role]
  is_this_role = imply_role.include? node['fqdn'] if imply_role

  template "#{unit_path}/imply-#{role}.service" do
    source 'systemd/imply.service.erb'
    variables(
      user: node['imply-platform']['user'],
      group: node['imply-platform']['group'],
      prefix_root: node['imply-platform']['prefix_root'],
      role: role,
      role_conf:  node['imply-platform']["#{role}_conf"]
    )
    user 'root'
    group 'root'
    notifies :run, 'execute[imply-platform:reload-systemd]', :immediately
    only_if { is_this_role }
  end
end

# Reload systemd if changes in a service template file
execute 'imply-platform:reload-systemd' do
  command 'systemctl daemon-reload'
  action :nothing
end
