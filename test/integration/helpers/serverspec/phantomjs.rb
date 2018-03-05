#
# Copyright (c) 2018 Make.org
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

phantom_repo = 'http://li.nux.ro/download/nux/dextop/el7/x86_64/'
phantom_rpm = 'phantomjs-2.1.1-1.el7.nux.x86_64.rpm'
phantom_github = 'https://raw.githubusercontent.com/ariya/phantomjs'
rasterize_js = "#{phantom_github}/master/examples/rasterize.js"

cmd = <<-BASH
  http_proxy='' https_proxy='' \
  set -e && \
  cd /root && \
  if [ ! -s #{phantom_rpm} ]; then
    curl -o #{phantom_rpm} "#{phantom_repo}/#{phantom_rpm}" && \
    yum install -y #{phantom_rpm};
  fi && \
  if [ ! -s rasterize.js ]; then
    curl -o rasterize.js #{rasterize_js};
  fi
BASH

describe 'PhantomJS' do
  it 'should help test if Pivot works' do
    expect(command(cmd).exit_status).to eq(0)
  end
end

def rasterize
  `cd /root; phantomjs rasterize.js http://localhost:9095 pivot.png`
end
