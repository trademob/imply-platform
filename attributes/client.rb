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

# Define useful cookbook_name macro
cookbook_name = 'imply-platform'

default[cookbook_name]['druid']['config']['components']['pivot'] = {
  'port' => 9095,
  'varDir' => "#{node[cookbook_name]['var_dir']}/pivot",
  'initialSettings' => {
    'connections' => {
      'druid' => { # key is used as name (better than array)
        'type' => 'druid',
        'title' => 'My Druid',
        'host' => '', # localhost:8082
        'coordinatorHosts' => [], # localhost:8081
        'overlordHosts' => [] # localhost:8090
      }
    }
  },
  # TODO: use the same db as other services
  'stateStore' => {
    'type' => 'sqlite',
    'connection' => "#{node[cookbook_name]['var_dir']}/pivot-settings.sqlite"
  }
}
