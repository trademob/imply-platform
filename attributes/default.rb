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

# imply package
default['imply-platform']['version'] = '2.0.0'
imply_version = node['imply-platform']['version']

# Checksum of imply tarball
default['imply-platform']['checksum'] =
  '1d5c483feb74b41e3870079d94b52fa110a66780810208c693c1ebad9c0ce85f'

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
# var dir
default['imply-platform']['var_dir'] = '/var/opt/imply'
var = node['imply-platform']['var_dir']
# Where to log
default['imply-platform']['log_dir'] = "#{var}/log"
# Tmp dir
default['imply-platform']['tmp_dir'] = "#{var}/tmp"

# Java package to install by platform
default['imply-platform']['java'] = {
  'centos' => 'java-1.8.0-openjdk-headless'
}

# Package to install to get mysql command, by platform
# Only needed if external database is mysql like
default['imply-platform']['mysql'] = {
  'centos' => 'mariadb'
}

# Systemd unit file path
default['imply-platform']['unit_path'] = '/etc/systemd/system'

# Druid components per Imply role
default['imply-platform']['components_per_role'] = {
  'master' => %w(coordinator overlord),
  'data' => %w(historical middleManager),
  'query' => %w(broker),
  'client' => %w(pivot)
}

# Metadata configuration
default['imply-platform']['metadata']['database'] = 'druid'
default['imply-platform']['metadata']['user']['login'] = 'root'
default['imply-platform']['metadata']['server']['port'] = 3306

# Number of retries to execute in order to perform db creation
default['imply-platform']['database_creation_retries'] = nil
default['imply-platform']['database_creation_retry_delay'] = nil

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
  'druid.storage.storageDirectory' => "#{var}/druid/segments",
  'druid.indexer.logs.type' => 'file',
  'druid.indexer.logs.directory' => "#{var}/druid/indexing-logs",
  'druid.indexer.task.chathandler.type' => 'announce',
  'druid.selectors.indexing.serviceName' => 'druid/overlord',
  'druid.selectors.coordinator.serviceName' => 'druid/coordinator',
  'druid.monitoring.monitors' => '["com.metamx.metrics.JvmMonitor"]',
  'druid.emitter' => 'noop',
  'druid.emitter.logging.logLevel' => 'debug'
}

# Druid JVM common properties (will be merge in each components)
default['imply-platform']['druid']['config']['jvm']['common'] = {
  '-Duser.timezone' => 'UTC',
  '-Dfile.encoding' => 'UTF-8',
  '-Djava.io.tmpdir' => "#{node['imply-platform']['tmp_dir']}/%{component}",
  '-Djava.util.logging.manager' => 'org.apache.logging.log4j.jul.LogManager',
  '-Dlog4j2.dir' => node['imply-platform']['log_dir'],
  '-Dlog4j2.appender' => 'file',
  '-Dservice' => '%{component}'
}

# Log4j2 config for all components
default['imply-platform']['druid']['config']['log4j2'] = {
  'Configuration' => [{
    'monitorInterval' => '60',
    'Properties' => [{
      'Property' =>
      [
        {
          'name' => 'logfile.path',
          'content' => '${sys:log4j2.dir}/${sys:service}.log'
        }
      ]
    }],
    'Appenders' => [{
      'RollingFile' =>
      [
        {
          'name' => 'file',
          'fileName' => '${logfile.path}',
          'filePattern' => '${logfile.path}.%i.gz',
          'PatternLayout' => [{
            'pattern' => ['%d{ISO8601} %p [%t] %c - %m%n']
          }],
          'Policies' => [{
            'SizeBasedTriggeringPolicy' => [{
              'size' => '1 GB'
            }]
          }],
          'DefaultRolloverStrategy' => [{
            'max' => '9'
          }]
        }
      ],
      'Console' => [
        {
          'name' => 'console',
          'PatternLayout' => [{
            'pattern' => ['%d{ISO8601} %p [%t] %c - %m%n']
          }]
        }
      ]
    }],
    'Loggers' => [{
      'Root' => [{
        'level' => 'info',
        'AppenderRef' => [{ 'ref' => '${sys:log4j2.appender}' }]
      }]
    }]
  }]
}

# Config for Pivot deployed on a standalone host using pivot recipe
default['imply-platform']['pivot']['port'] = 9095
default['imply-platform']['pivot']['broker'] = nil

# NodeJS package for pivot
default['imply-platform']['nodejs']['mirror'] =
  'https://rpm.nodesource.com/pub_4.x/el/$releasever/$basearch'
default['imply-platform']['nodejs']['gpgkey'] =
  'https://rpm.nodesource.com/pub/el/NODESOURCE-GPG-SIGNING-KEY-EL'

# Auto restart services if change in a config file has been spotted
default['imply-platform']['auto_restart'] = true

# Configure retries for the package resources, default = global default (0)
# (mostly used for test purpose
default['imply-platform']['package_retries'] = nil
