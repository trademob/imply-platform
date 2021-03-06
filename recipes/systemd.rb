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

# Deploy systemd unit files
unit_path = node[cookbook_name]['unit_path']
components_per_role = node[cookbook_name]['components_per_role']

%w[master data query client].each do |role|
  # Deploy template if node has role
  imply_role = node.run_state[cookbook_name][role]
  next unless imply_role && imply_role.include?(node['fqdn'])

  components_per_role[role].each do |service|
    type = 'druid'
    if service == 'pivot'
      type = 'pivot'
      service = ''
    end
    service_name = "imply-#{type}#{"-#{service}" unless service.empty?}"
    template "#{unit_path}/#{service_name}.service" do
      source 'systemd/imply.service.erb'
      variables(
        user: node[cookbook_name]['user'],
        group: node[cookbook_name]['group'],
        prefix_root: node[cookbook_name]['prefix_root'],
        type: type,
        service: service
      )
      user 'root'
      group 'root'
      notifies :run, 'execute[imply-platform:reload-systemd]', :immediately
    end
  end
end

# Reload systemd if changes in a service template file
execute 'imply-platform:reload-systemd' do
  command 'systemctl daemon-reload'
  action :nothing
end
