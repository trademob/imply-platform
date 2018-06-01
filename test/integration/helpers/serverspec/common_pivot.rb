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
require 'phantomjs'

def wait_pivot_source(cmd)
  (1..60).each do |try|
    rasterize
    break if system(cmd)
    puts "Waiting for pivot datasource… Try ##{try}/60, waiting 3s"
    sleep(3)
  end
end

describe 'Imply Pivot' do
  it 'is running' do
    expect(service('imply-pivot')).to be_running
  end

  it 'is launched at boot' do
    expect(service('imply-pivot')).to be_enabled
  end

  it 'has Pivot listening on correct port' do
    expect(port(9095)).to be_listening
  end

  it 'should have a dataset configured' do
    pattern = '"POST /datasets/datasource/load HTTP/1.1" 200'
    cmd = "journalctl -u imply-pivot | grep '#{pattern}' 2>&1 >/dev/null"
    wait_pivot_source(cmd)
    expect(command(cmd).exit_status).to eq(0)
  end
end
