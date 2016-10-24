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

# Cluster Search (cluster-search) is a simple cookbook library which simplify
# the search of members of a cluster. It relies on Chef search with a size
# guard (to avoid inconsistencies during initial convergence) and allows a
# fall-back to hostname listing if user does not want to rely on searches
# (because of chef-solo for example).

# In the following bloc of 3 lines:
# - role is the target role for the search
# - unempty hosts deactivates search, it's the member list of the cluster
# - size is the expected size of the searched cluster, ignored if hosts is used

default['imply-platform']['master']['role'] = 'master-imply-platform'
default['imply-platform']['master']['hosts'] = []
default['imply-platform']['master']['size'] = 1

default['imply-platform']['data']['role'] = 'data-imply-platform'
default['imply-platform']['data']['hosts'] = []
default['imply-platform']['data']['size'] = 1

default['imply-platform']['query']['role'] = 'query-imply-platform'
default['imply-platform']['query']['hosts'] = []
default['imply-platform']['query']['size'] = 1

default['imply-platform']['client']['role'] = 'client-imply-platform'
default['imply-platform']['client']['hosts'] = []
default['imply-platform']['client']['size'] = 1

default['imply-platform']['zookeeper']['role'] = 'zookeeper-cluster'
default['imply-platform']['zookeeper']['hosts'] = []
default['imply-platform']['zookeeper']['size'] = 1

default['imply-platform']['database']['role'] = 'mariadb-galera-cluster'
default['imply-platform']['database']['hosts'] = []
default['imply-platform']['database']['size'] = 1
