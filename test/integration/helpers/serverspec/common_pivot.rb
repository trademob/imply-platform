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

def wait_pivot_data(cmd)
  (1..24).each do |try|
    output = `#{cmd}`
    break if
      output.include?("Adding data cube manager for \'druid-pageviews-0\'")
    puts "Waiting for pivot datasource… Try ##{try}/24, waiting 5s"
    sleep(5)
  end
end

describe 'Imply Pivot' do
  it 'is running' do
    expect(service('imply-pivot')).to be_running
  end

  it 'is launched at boot' do
    expect(service('imply-pivot')).to be_enabled
  end

  wait_service('pivot', 9095)

  it 'has Pivot listening on correct port' do
    expect(port(9095)).to be_listening
  end

  it 'should have added a data cube' do
    cmd =
      'systemctl restart imply-pivot && journalctl -u imply-pivot | grep \
      "Adding data cube manager for \'druid-pageviews-0\'"'
    wait_pivot_data(cmd)
    expect(command(cmd).exit_status).to eq(0)
  end
end
