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

require 'serverspec'

set :backend, :exec

def wait_service(service, port)
  (1..60).each do |try|
    out = `ss -tunl | grep -- :#{port.to_s}`
    break unless out.empty?
    puts "Waiting to #{service} to launch… (##{try}/60), waiting 3s"
    sleep(3)
  end
end
