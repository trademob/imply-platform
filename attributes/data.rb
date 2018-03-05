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

default[cookbook_name]['druid']['config']['jvm']['historical'] = {
  '-Xms' => '8g',
  '-Xmx' => '8g'
}
default[cookbook_name]['druid']['config']['jvm']['middleManager'] = {
  '-Xms' => '64m',
  '-Xmx' => '64m'
}

var = node[cookbook_name]['var_dir']

default[cookbook_name]['druid']['config']['components']['historical'] = {
  'druid.service' => 'druid/historical',
  'druid.port' => 8083,
  'druid.server.http.numThreads' => 40,
  'druid.processing.buffer.sizeBytes' => 536_870_912,
  'druid.processing.numThreads' => 7,
  'druid.segmentCache.locations' =>
    "[{\"path\":\"#{var}/druid/segment-cache\",\"maxSize\"\:130000000000}]",
  'druid.server.maxSize' => 130_000_000_000,
  'druid.historical.cache.useCache' => 'true',
  'druid.historical.cache.populateCache' => 'true',
  'druid.cache.type' => 'local',
  'druid.cache.sizeInBytes' => 2_000_000_000
}

common = node[cookbook_name]['druid']['config']['common_runtime_properties']
logdir = common['druid.indexer.logs.directory']

default[cookbook_name]['druid']['config']['components']['middleManager'] = {
  'druid.service' => 'druid/middlemanager',
  'druid.port' => 8091,
  'druid.worker.capacity' => 3,
  'druid.indexer.runner.javaOpts' =>
  "-server -Xmx2g -Duser.timezone=UTC -Dfile.encoding=UTF-8 \
    -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager \
    -Dservice=peon -Dlog4j2.dir=#{logdir} -Dlog4j2.appender=console",
  'druid.indexer.task.baseTaskDir' => "#{var}/druid/task",
  'druid.indexer.task.restoreTasksOnRestart' => 'true',
  'druid.server.http.numThreads' => 40,
  'druid.processing.buffer.sizeBytes' => 536_870_912,
  'druid.processing.numThreads' => 2,
  'druid.indexer.task.hadoopWorkingPath' => "#{var}/druid/hadoop-tmp",
  'druid.indexer.task.defaultHadoopCoordinates' =>
    '["org.apache.hadoop:hadoop-client:2.7.3"]'
}
