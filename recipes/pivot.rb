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

# Set-up imply user/group for pivot
include_recipe "#{cookbook_name}::user"

# Install nodejs
include_recipe "#{cookbook_name}::nodejs"

# Use npm to install pivot
execute 'install pivot' do
  command <<-EOF
    npm install -g imply-pivot
  EOF
  cwd '/root'
  creates '/usr/bin/pivot'
end

# Deploy systemd unit file for pivot
unit_path = node['imply-platform']['unit_path']

template "#{unit_path}/pivot.service" do
  source 'systemd/pivot.service.erb'
  variables(
    user: node['imply-platform']['user'],
    group: node['imply-platform']['group'],
    pivot_port:  node['imply-platform']['pivot']['port'],
    druid_broker:  node['imply-platform']['pivot']['broker']
  )
  user 'root'
  group 'root'
  notifies :run, 'execute[pivot:reload-systemd]', :immediately
end

# Reload systemd if changes in a pivot unit template file
execute 'pivot:reload-systemd' do
  command 'systemctl daemon-reload'
  action :nothing
end

# Enable and start pivot service
service 'pivot' do
  action [:enable, :start]
end
