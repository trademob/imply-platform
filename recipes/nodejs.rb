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

# Install nodejs if node have the query role defined
if node.run_state['imply-platform']['query']
  # Set repository for nodejs installation needed by query imply service
  yum_repository 'nodesource' do
    description 'NodeJS repository'
    baseurl node['imply-platform']['nodejs']['mirror']
    gpgkey node['imply-platform']['nodejs']['gpgkey']
    action :create
  end

  # Install nodejs
  package 'nodejs' do
    action :install
  end
end
