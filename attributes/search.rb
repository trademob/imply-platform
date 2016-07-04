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

# Role used by the search to find other master nodes of the cluster
default['imply-platform']['master']['role'] = 'imply-platform'
# Master hosts of the cluster, deactivate search if not empty
default['imply-platform']['master']['hosts'] = []
# Expected size of the master cluster. Ignored if hosts is not empty
default['imply-platform']['master']['size'] = 1

# Role used by the search to find other data nodes of the cluster
default['imply-platform']['data']['role'] = 'imply-platform'
# Data hosts of the cluster, deactivate search if not empty
default['imply-platform']['data']['hosts'] = []
# Expected size of the data cluster. Ignored if hosts is not empty
default['imply-platform']['data']['size'] = 1

# Role used by the search to find other query nodes of the cluster
default['imply-platform']['query']['role'] = 'imply-platform'
# Query hosts of the cluster, deactivate search if not empty
default['imply-platform']['query']['hosts'] = []
# Expected size of the query cluster. Ignored if hosts is not empty
default['imply-platform']['query']['size'] = 1

# Role used by the search to find other zookeeper nodes of the cluster
default['imply-platform']['zookeeper']['role'] = 'zookeeper-cluster'
# Zookeeper hosts of the cluster, deactivate search if not empty
default['imply-platform']['zookeeper']['hosts'] = []
# Expected size of the zookeeper cluster. Ignored if hosts is not empty
default['imply-platform']['zookeeper']['size'] = 1

# Role used by the search to find other database nodes of the cluster
default['imply-platform']['database']['role'] = 'mariadb-galera-cluster'
# database hosts of the cluster, deactivate search if not empty
default['imply-platform']['database']['hosts'] = []
# Expected size of the database cluster. Ignored if hosts is not empty
default['imply-platform']['database']['size'] = 1
