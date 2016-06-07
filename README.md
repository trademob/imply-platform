Exploratory Analytics, Scalable to Petabytes
=============

Description
-----------

Druid is an open source, distributed analytics data store.
This cookbook is designed to install and configure Druid using Imply solution.

Requirements
------------

### Cookbooks and gems

Declared in [metadata.rb](metadata.rb) and in [Gemfile](Gemfile).

### Platforms

A *systemd* managed distribution:
- RHEL Family 7, tested on Centos

Usage
-----

### Easy Setup

By default, this cookbook installs *openjdk* from the official repositories
*(openjdk-headless 8 on centos 7)* just before starting the service. You can
change this behavior by setting `node['imply-platform']['java']` to `""`, or
choose your package by setting the package name in
`node['imply-platform']['java'][node[:platform]]`.

### Search

The recommended way to use this cookbook is through the creation of a role
per **imply** cluster. This enables the search by role feature, allowing a
simple service discovery.

In fact, there are two ways to configure the search:
1. with a static configuration through a list of hostnames (attributes `hosts`
   that is `['imply-platform']['hosts']`)
2. with a real search, performed on a role (attributes `role` and `size`
   like in `['imply-platform']['role']`). The role should be in the run-list
   of all nodes of the cluster. The size is a safety and should be the number
   of nodes in the cluster.

If hosts is configured, `role` and `size` are ignored

See [roles](test/integration/roles) for some examples and
[Cluster Search][cluster-search] documentation for more information.

### Zookeeper HA Cluster

To install properly a HA **imply** cluster, you need a **Zookeeper** cluster.
This is not in the scope of this cookbook but if you need one, you should
consider using [Zookeeper Platform][zookeeper-platform].

The configuration of Zookeeper hosts use search and is done similarly as for
**imply** hosts, _ie_ with a static list of hostnames or by using a search on
a role. The attribute to configure is `['imply-platform']['zookeeper']`.


### Metadata HA Cluster

To install properly a HA **imply** cluster, you should have a metadata
sql cluster.
This is not in the scope of this cookbook but if you need one, you should
consider using [Galera Platform][galera-platform].

### Test

This cookbook is fully tested through the installation of the full platform
in docker hosts. This uses kitchen, docker and some monkey-patching.

If you run `kitchen list`, you will see 4 suites:

- zookeeper-centos-7
- imply-platform-1-centos-7
- imply-platform-2-centos-7
- imply-platform-3-centos-7

Each corresponds to a different node in the cluster. They are connected through
a bridge network named *kitchen*, which is created if necessary.

For more information, see [.kitchen.yml](.kitchen.yml) and [test](test)
directory.

Attributes
----------

Configuration is done by overriding default attributes. All configuration keys
have a default defined in [attributes/default.rb](attributes/default.rb).
Please read it to have a comprehensive view of what and how you can configure
this cookbook behavior.

Recipes
-------

### default

Default recipe

### user

Create user and group for Imply.

### install

Install Imply using a tarball package.

### config

Configure Imply, searching for other cluster members if available.

### systemd

Create systemd unit files

### service

Enable and start services

Resources/Providers
-------------------

None.

Changelog
---------

Available in [CHANGELOG.md](CHANGELOG.md).

Contributing
------------

Please read carefully [CONTRIBUTING.md](CONTRIBUTING.md) before making a merge
request.

License and Author
------------------

- Author:: Samuel Bernard (<samuel.bernard@s4m.io>)
- Author:: Florian Philippon (<florian.philippon@s4m.io>)

```text
Copyright (c) 2016 Sam4Mobile

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
