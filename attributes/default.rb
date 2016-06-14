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

# Configuration about the encrypted data bag containing the keys
default['imply-platform']['data_bag']['name'] = 'secrets'
default['imply-platform']['data_bag']['item'] = 'mariadb-credentials'
# Key used to load the value in data bag containing the password
default['imply-platform']['data_bag']['key'] = 'password'

# Associate node id to role
# Node id is defined when using the cluster-search
default['imply-platform']['master']['ids'] = []
default['imply-platform']['data']['ids'] = []
default['imply-platform']['query']['ids'] = []

# Cluster configuration with cluster-search
# Role used by the search to find other nodes of the cluster
default['imply-platform']['role'] = 'imply-platform'
# Hosts of the cluster, deactivate search if not empty
default['imply-platform']['hosts'] = []
# Expected size of the cluster. Ignored if hosts is not empty
default['imply-platform']['size'] = 1

# Zookeeper cluster
default['imply-platform']['zookeeper']['role'] = 'zookeeper-cluster'
default['imply-platform']['zookeeper']['hosts'] = []
default['imply-platform']['zookeeper']['size'] = 1

# MariaDB Galera clusrer
default['imply-platform']['mariadb']['role'] = 'mariadb-galera-cluster'
default['imply-platform']['zookeeper']['size'] = 1

# imply package
default['imply-platform']['version'] = '1.2.1'
imply_version = node['imply-platform']['version']

# Checksum of imply tarball
default['imply-platform']['checksum'] =
  'b47195cdd20f2630ecc05e989955d3df5a0be122a0d9e14fb0f80fefa6c07a64'

# imply url
default['imply-platform']['url'] = 'http://static.imply.io/release'
url = node['imply-platform']['url']

# imply mirror
default['imply-platform']['mirror'] = "#{url}/imply-#{imply_version}.tar.gz"

# User and group of imply process
default['imply-platform']['user'] = 'imply'
default['imply-platform']['group'] = 'imply'
# Where to put installation dir
default['imply-platform']['prefix_root'] = '/opt'
# Where to link installation dir
default['imply-platform']['prefix_home'] = '/opt'
# Where to link binaries
default['imply-platform']['prefix_bin'] = '/opt/bin'

# Java package to install by platform
default['imply-platform']['java'] = {
  'centos' => 'java-1.8.0-openjdk-headless'
}

# NodeJS package
default['imply-platform']['nodejs']['mirror'] =
  'https://rpm.nodesource.com/pub_4.x/el/$releasever/$basearch'
default['imply-platform']['nodejs']['gpgkey'] =
  'https://rpm.nodesource.com/pub/el/NODESOURCE-GPG-SIGNING-KEY-EL'

# Systemd unit file path
default['imply-platform']['unit_path'] = '/etc/systemd/system'

# Metadata configuration

default['imply-platform']['metadata']['database'] = 'druid'
default['imply-platform']['metadata']['server']['host'] = 'localhost'
default['imply-platform']['metadata']['user']['login'] = 'root'

# Druid common properties
default['imply-platform']['druid']['config']['common_runtime_properties'] = {
  'druid.extensions.directory' => 'dist/druid/extensions',
  'druid.extensions.hadoopDependenciesDir' => 'dist/druid/hadoop-dependencies',
  'druid.extensions.loadList' => '["mysql-metadata-storage"]',
  'druid.startup.logging.logProperties' => 'true',
  'druid.zk.service.host' => '',
  'druid.zk.paths.base' => '/druid',
  'druid.metadata.storage.type' => 'mysql',
  'druid.metadata.storage.connector.user' =>
    node['imply-platform']['metadata']['user']['login'],
  'druid.storage.type' => 'local',
  'druid.storage.storageDirectory' => 'var/data/druid/segments',
  'druid.indexer.logs.type' => 'file',
  'druid.indexer.logs.directory' => 'var/data/druid/indexing-logs',
  'druid.indexer.task.chathandler.type' => 'announce',
  'druid.selectors.indexing.serviceName' => 'druid/overlord',
  'druid.selectors.coordinator.serviceName' => 'druid/coordinator',
  'druid.monitoring.monitors' => '["com.metamx.metrics.JvmMonitor"]',
  'druid.emitter' => 'logging',
  'druid.emitter.logging.logLevel' => 'info'
}

# Druid jvm config per component
default['imply-platform']['druid']['config']['jvm'] = {
  'broker' => {
    'jvmkey1' => '-server',
    'jvmkey2' => '-Xms24g',
    'jvmkey3' => '-Xmx24g',
    '-XX:MaxDirectMemorySize' => '4096m',
    '-Duser.timezone' => 'UTC',
    '-Dfile.encoding' => 'UTF-8',
    '-Djava.io.tmpdir' => 'var/query/tmp',
    '-Djava.util.logging.manager' =>
      'org.apache.logging.log4j.jul.LogManager'
  },
  'coordinator' => {
    'jvmkey1' => '-server',
    'jvmkey2' => '-Xms3g',
    'jvmkey3' => '-Xmx3g',
    '-Duser.timezone' => 'UTC',
    '-Dfile.encoding' => 'UTF-8',
    '-Djava.io.tmpdir' => 'var/master/tmp',
    '-Djava.util.logging.manager' =>
      'org.apache.logging.log4j.jul.LogManager',
    '-Dderby.stream.error.file' => 'var/druid/derby.log'
  },
  'historical' => {
    'jvmkey1' => '-server',
    'jvmkey2' => '-Xms8g',
    'jvmkey3' => '-Xmx8g',
    '-Duser.timezone' => 'UTC',
    '-Dfile.encoding' => 'UTF-8',
    '-Djava.io.tmpdir' => 'var/data/tmp',
    '-Djava.util.logging.manager' =>
      'org.apache.logging.log4j.jul.LogManager'
  },
  'middleManager' => {
    'jvmkey1' => '-server',
    'jvmkey2' => '-Xms64m',
    'jvmkey3' => '-Xmx64m',
    '-Duser.timezone' => 'UTC',
    '-Dfile.encoding' => 'UTF-8',
    '-Djava.io.tmpdir' => 'var/data/tmp',
    '-Djava.util.logging.manager' =>
      'org.apache.logging.log4j.jul.LogManager'
  },
  'overlord' => {
    'jvmkey1' => '-server',
    'jvmkey2' => '-Xms3g',
    'jvmkey3' => '-Xmx3g',
    '-Duser.timezone' => 'UTC',
    '-Dfile.encoding' => 'UTF-8',
    '-Djava.io.tmpdir' => 'var/master/tmp',
    '-Djava.util.logging.manager' =>
      'org.apache.logging.log4j.jul.LogManager'
  }
}

# Supervise path includes startup scripts to easily
# start up servers.
imply_supervise_path =
  "#{node['imply-platform']['prefix_home']}/imply/conf/supervise"

# Master config file with no zookeeper embedded
default['imply-platform']['master_conf'] =
  "#{imply_supervise_path}/master-no-zk.conf"
# Data config file
default['imply-platform']['data_conf'] =
  "#{imply_supervise_path}/data.conf"
# Query config file
default['imply-platform']['query_conf'] =
  "#{imply_supervise_path}/query.conf"

# Start all services (master,query,data) on node if true
node.default['imply-platform']['standalone'] = false
