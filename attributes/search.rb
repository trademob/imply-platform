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

# Define useful cookbook_name macro
cookbook_name = 'imply-platform'

# Cluster Search (cluster-search) is a simple cookbook library which simplify
# the search of members of a cluster. It relies on Chef search with a size
# guard (to avoid inconsistencies during initial convergence) and allows a
# fall-back to hostname listing if user does not want to rely on searches
# (because of chef-solo for example).

# In the following bloc of 3 lines:
# - role is the target role for the search
# - unempty hosts deactivates search, it's the member list of the cluster
# - size is the expected size of the searched cluster, ignored if hosts is used

default[cookbook_name]['master']['role'] = 'master-imply-platform'
default[cookbook_name]['master']['hosts'] = []
default[cookbook_name]['master']['size'] = 1

default[cookbook_name]['data']['role'] = 'data-imply-platform'
default[cookbook_name]['data']['hosts'] = []
default[cookbook_name]['data']['size'] = 1

default[cookbook_name]['query']['role'] = 'query-imply-platform'
default[cookbook_name]['query']['hosts'] = []
default[cookbook_name]['query']['size'] = 1

default[cookbook_name]['client']['role'] = 'client-imply-platform'
default[cookbook_name]['client']['hosts'] = []
default[cookbook_name]['client']['size'] = 1

default[cookbook_name]['zookeeper']['role'] = 'zookeeper-cluster'
default[cookbook_name]['zookeeper']['hosts'] = []
default[cookbook_name]['zookeeper']['size'] = 1

default[cookbook_name]['database']['role'] = 'mariadb-galera-cluster'
default[cookbook_name]['database']['hosts'] = []
default[cookbook_name]['database']['size'] = 1
