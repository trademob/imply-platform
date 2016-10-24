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

include_recipe "#{cookbook_name}::search"
include_recipe "#{cookbook_name}::user"
include_recipe "#{cookbook_name}::install"

# Install nodejs for clients
if node.run_state['imply-platform']['my_roles'].include?('client')
  include_recipe "#{cookbook_name}::nodejs"
end

# Connect to database for others
unless (node.run_state['imply-platform']['my_roles'] - ['client']).empty?
  include_recipe "#{cookbook_name}::database"
end

include_recipe "#{cookbook_name}::config"
include_recipe "#{cookbook_name}::systemd"
include_recipe "#{cookbook_name}::service"
