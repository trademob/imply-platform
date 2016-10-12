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

def wait_pivot_data
  (1..30).each do |try|
    pivot_log = File.read('/opt/imply/var/query/sv/pivot.log')
    break if pivot_log.include?("Adding Data Cube: 'pageviews'")
    puts "Waiting for pivot datasource… Try ##{try}/30, waiting 5s"
    sleep(5)
  end
end

describe 'Imply query' do
  it 'is running' do
    expect(service('imply-query')).to be_running
  end

  it 'is launched at boot' do
    expect(service('imply-query')).to be_enabled
  end

  it 'has Druid Broker listening on correct port' do
    expect(port(8082)).to be_listening
  end

  it 'has Pivot listening on correct port' do
    expect(port(9095)).to be_listening
  end

  describe file('/var/opt/imply/log/broker.log') do
    its(:content) { should contain 'Started @' }
  end

  describe file('/opt/imply/var/query/sv/pivot.log') do
    wait_pivot_data
    its(:content) { should contain "Adding Data Cube: 'pageviews'" }
  end
end
