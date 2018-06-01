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

package_retries = node[cookbook_name]['package_retries']
# Set repository for nodejs installation needed by query imply service
yum_repository 'nodesource' do
  description 'NodeJS repository'
  baseurl node[cookbook_name]['nodejs']['mirror']
  gpgkey node[cookbook_name]['nodejs']['gpgkey']
  retries package_retries unless package_retries.nil?
  action :create
end

# Install nodejs
package 'nodejs' do
  action :install
  retries package_retries unless package_retries.nil?
end
