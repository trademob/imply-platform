name 'imply-platform'
maintainer 'Make.org'
maintainer_email 'sre@make.org'
license 'Apache-2.0'
description 'Install and configure Imply/druid'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url 'https://gitlab.com/chef-platform/imply-platform'
issues_url 'https://gitlab.com/chef-platform/imply-platform/issues'
version '4.0.0'

supports 'centos', '>= 7.1'

chef_version '>= 13.0'

depends 'ark'
depends 'cluster-search'
depends 'database'
