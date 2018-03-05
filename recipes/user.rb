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

# Define imply group
group node[cookbook_name]['group'] do
  append node[cookbook_name]['group_append']
  system true
end

# Define imply user
user node[cookbook_name]['user'] do
  comment 'imply service account'
  group node[cookbook_name]['group']
  system true
  shell '/sbin/nologin'
end
