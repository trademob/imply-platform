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

require 'spec_helper'

describe 'Imply master' do
  %w[coordinator overlord].each do |service|
    it 'is running' do
      expect(service("imply-druid-#{service}")).to be_running
    end

    it 'is launched at boot' do
      expect(service("imply-druid-#{service}")).to be_enabled
    end
  end

  wait_service('coordinator', 8081)
  wait_service('overlord', 8090)

  it 'has Druid Coordinator listening on correct port' do
    expect(port(8081)).to be_listening
  end

  it 'has Druid Overlord listening on correct port' do
    expect(port(8090)).to be_listening
  end

  it 'is able to launch indexing task' do
    proxy = 'http_proxy="" HTTP_PROXY=""'
    post_index = 'no_proxy=localhost,.kitchen /opt/imply/bin/post-index-task'
    post_parameters = '--url http://localhost:8090 --submit-timeout 600'
    index_task = '--file /opt/imply/tests/test-index-task.json'
    result = `#{proxy} #{post_index} #{post_parameters} #{index_task} 2>&1`
    expect(result).to include('Task finished with status: SUCCESS')
  end
end
