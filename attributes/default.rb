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

# Configuration about the encrypted data bag containing the keys
default[cookbook_name]['data_bag']['name'] = 'secrets'
default[cookbook_name]['data_bag']['item'] = 'mariadb-credentials'
# Key used to load the value in data bag containing the password
default[cookbook_name]['data_bag']['key'] = 'password'

# imply package
default[cookbook_name]['version'] = '2.5.15'
imply_version = node[cookbook_name]['version']

# Checksum of imply tarball
default[cookbook_name]['checksum'] =
  'eb888c5f38dccb59dd9418006a39867432108a5850d7f1a14e068576fcd154ba'

# imply url
default[cookbook_name]['url'] = 'http://static.imply.io/release'
url = node[cookbook_name]['url']

# imply mirror
default[cookbook_name]['mirror'] = "#{url}/imply-#{imply_version}.tar.gz"

# User and group of imply process
default[cookbook_name]['user'] = 'imply'
default[cookbook_name]['group'] = node[cookbook_name]['user']
default[cookbook_name]['group_append'] = true

# User and group of imply storage dir (deep storage & indexing logs)
default[cookbook_name]['storage_dir']['user'] =
  node[cookbook_name]['user']
default[cookbook_name]['storage_dir']['group'] =
  node[cookbook_name]['group']
default[cookbook_name]['storage_dir']['mode'] = '0750'

# Where to put installation dir
default[cookbook_name]['prefix_root'] = '/opt'
# Where to link installation dir
default[cookbook_name]['prefix_home'] = '/opt'
# Where to link binaries
default[cookbook_name]['prefix_bin'] = '/opt/bin'
# var dir
default[cookbook_name]['var_dir'] = '/var/opt/imply'
var = node[cookbook_name]['var_dir']
# Where to log
default[cookbook_name]['log_dir'] = "#{var}/log"
# Tmp dir
default[cookbook_name]['tmp_dir'] = "#{var}/tmp"

# Java package to install by platform
default[cookbook_name]['java'] = {
  'centos' => 'java-1.8.0-openjdk-headless'
}

# Package to install to get mysql command, by platform
# Only needed if external database is mysql like
default[cookbook_name]['mysql'] = {
  'centos' => 'mariadb'
}

# Systemd unit file path
default[cookbook_name]['unit_path'] = '/etc/systemd/system'

# Druid components per Imply role
default[cookbook_name]['components_per_role'] = {
  'master' => %w[coordinator overlord],
  'data' => %w[historical middleManager],
  'query' => %w[broker],
  'client' => %w[pivot]
}

# Metadata configuration
default[cookbook_name]['metadata']['database'] = 'druid'
default[cookbook_name]['metadata']['user']['login'] = 'root'
default[cookbook_name]['metadata']['server']['port'] = 3306

# Number of retries to execute in order to perform db creation
default[cookbook_name]['database_creation_retries'] = nil
default[cookbook_name]['database_creation_retry_delay'] = nil

# Druid common properties
default[cookbook_name]['druid']['config']['common_runtime_properties'] = {
  'druid.extensions.directory' => 'dist/druid/extensions',
  'druid.extensions.hadoopDependenciesDir' => 'dist/druid/hadoop-dependencies',
  'druid.extensions.loadList' => '["mysql-metadata-storage"]',
  'druid.startup.logging.logProperties' => 'true',
  'druid.zk.service.host' => '',
  'druid.zk.paths.base' => '/druid',
  'druid.metadata.storage.type' => 'mysql',
  'druid.metadata.storage.connector.user' =>
    node[cookbook_name]['metadata']['user']['login'],
  'druid.storage.type' => 'local',
  'druid.storage.storageDirectory' => "#{var}/druid/segments",
  'druid.indexer.logs.type' => 'file',
  'druid.indexer.logs.directory' => "#{var}/druid/indexing-logs",
  'druid.indexer.task.chathandler.type' => 'announce',
  'druid.selectors.indexing.serviceName' => 'druid/overlord',
  'druid.selectors.coordinator.serviceName' => 'druid/coordinator',
  'druid.monitoring.monitors' => '["com.metamx.metrics.JvmMonitor"]',
  'druid.emitter' => 'noop',
  'druid.emitter.logging.logLevel' => 'debug',
  'druid.sql.enable' => true
}

# Druid JVM common properties (will be merge in each components)
default[cookbook_name]['druid']['config']['jvm']['common'] = {
  '-Duser.timezone' => 'UTC',
  '-Dfile.encoding' => 'UTF-8',
  '-Djava.io.tmpdir' => "#{node[cookbook_name]['tmp_dir']}/%<component>s",
  '-Djava.util.logging.manager' => 'org.apache.logging.log4j.jul.LogManager',
  '-Dlog4j2.dir' => node[cookbook_name]['log_dir'],
  '-Dlog4j2.appender' => 'file',
  '-Dservice' => '%<component>s'
}

# Log4j2 config for all components
default[cookbook_name]['druid']['config']['log4j2'] = {
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
default[cookbook_name]['pivot']['port'] = 9095
default[cookbook_name]['pivot']['broker'] = nil

# NodeJS package for pivot
default[cookbook_name]['nodejs']['mirror'] =
  'https://rpm.nodesource.com/pub_4.x/el/$releasever/$basearch'
default[cookbook_name]['nodejs']['gpgkey'] =
  'https://rpm.nodesource.com/pub/el/NODESOURCE-GPG-SIGNING-KEY-EL'

# Auto restart services if change in a config file has been spotted
default[cookbook_name]['auto_restart'] = true

# Configure retries for the package resources, default = global default (0)
# (mostly used for test purpose
default[cookbook_name]['package_retries'] = nil
