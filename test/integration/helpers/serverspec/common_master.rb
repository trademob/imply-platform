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

require 'spec_helper'

describe 'Imply master' do
  it 'is running' do
    expect(service('imply-master')).to be_running
  end

  it 'is launched at boot' do
    expect(service('imply-master')).to be_enabled
  end

  it 'has Druid Coordinator listening on correct port' do
    expect(port(8081)).to be_listening
  end

  it 'has Druid Overlord listening on correct port' do
    expect(port(8090)).to be_listening
  end

  describe file('/opt/imply/var/sv/coordinator.log') do
    its(:content) { should contain 'Started @' }
  end

  describe file('/opt/imply/var/sv/overlord.log') do
    its(:content) { should contain 'Started @' }
  end

  it 'is able to launch indexing task' do
    post_index = 'no_proxy=localhost /opt/imply/bin/post-index-task'
    post_parameters = '--url http://localhost:8090/ --file'
    index_task = '/opt/imply/tests/test-index-task.json'
    result = `#{post_index} #{post_parameters} #{index_task} 2>&1`
    expect(result).to include('Task finished with status: SUCCESS')
  end
end
