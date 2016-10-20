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

default['imply-platform']['druid']['config']['jvm']['broker'] = {
  '-Xms' => '24g',
  '-Xmx' => '24g'
}

default['imply-platform']['druid']['config']['components']['broker'] = {
  'druid.service' => 'druid/broker',
  'druid.port' => 8082,
  'druid.broker.http.numConnections' => 5,
  'druid.server.http.numThreads' => 40,
  'druid.processing.buffer.sizeBytes' => 536_870_912,
  'druid.processing.numThreads' => 7,
  'druid.broker.cache.useCache' => 'false',
  'druid.broker.cache.populateCache' => 'false'
}
