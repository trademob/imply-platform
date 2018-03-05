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

default[cookbook_name]['druid']['config']['jvm']['coordinator'] = {
  '-Xms' => '3g',
  '-Xmx' => '3g'
}

default[cookbook_name]['druid']['config']['jvm']['overlord'] = {
  '-Xms' => '3g',
  '-Xmx' => '3g'
}

default[cookbook_name]['druid']['config']['components']['coordinator'] = {
  'druid.service' => 'druid/coordinator',
  'druid.port' => 8081,
  'druid.coordinator.startDelay' => 'PT30S',
  'druid.coordinator.period' => 'PT30S'
}

default[cookbook_name]['druid']['config']['components']['overlord'] = {
  'druid.service' => 'druid/overlord',
  'druid.port' => 8090,
  'druid.indexer.queue.startDelay' => 'PT30S',
  'druid.indexer.runner.type' => 'remote',
  'druid.indexer.storage.type' => 'metadata'
}
