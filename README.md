Exploratory Analytics, Scalable to Petabytes
=============

Description
-----------

[Druid](http://druid.io/) is an open source, high-performance, column-oriented,
distributed data store.

[Imply](https://imply.io/) is an open event analytics platform, powered by
Druid. Explore your events through interactive visualizations, SQL, or your own
custom applications.

This cookbook is designed to install and configure Druid using Imply
distribution.

Requirements
------------

### Cookbooks and gems

Declared in [metadata.rb](metadata.rb) and in [Gemfile](Gemfile).

### Platforms

A *systemd* managed distribution:
- RHEL Family 7, tested on Centos

Usage
-----

Druid need a lot of different nodes but Imply distribution sorts them in
three main roles:

- Master, everything about coordination
- Data, all about data
- Query, responsible for user requests
- Client (actually not an officiel Imply role) for clients like pivot

To setup an Imply cluster, you need to define which nodes you want to affect
to each role (a node may have multiple roles). This is done by the help of
[Cluster Search][cluster-search] cookbook.

### Search

The recommended way to use this cookbook is through the creation of four
Chef roles per Imply cluster, each mapping an Imply role.

This enables the search by role feature, allowing a simple service discovery.
The search should be parametrized in attributes:

- `node['imply-platform']['master']`
- `node['imply-platform']['data']`
- `node['imply-platform']['query']`
- `node['imply-platform']['client']`

In fact, for each there are two ways to configure the search:

1. with a static configuration through a list of hostnames (attributes `hosts`
   that is `node['imply-platform']['master']['hosts']` for the master role)
2. with a real search, performed on a role (attributes `role` and `size`
   like in `node['imply-platform']['master']['role']`). The role should be in
   the run-list of all nodes of the cluster. The size is a safety and should be
   the number of nodes of this role.

If hosts is configured, `role` and `size` are ignored

See [.kitchen.yml](.kitchen.yml) and [roles](test/integration/roles) for some
examples and [Cluster Search][cluster-search] documentation for more
information.

Note that if you want a simple (and static, ie without search) configuration
of your Imply cluster, you can use only one role declaring all your nodes
with **hosts** attributes.

### Zookeeper HA Cluster

To install properly a HA Imply cluster, you need a **Zookeeper** cluster.
This is not in the scope of this cookbook but if you need one, you should
consider using [Zookeeper Platform][zookeeper-platform].

The configuration of Zookeeper hosts use search and is done similarly as for
Imply hosts, _ie_ with a static list of hostnames or by using a search on
a role. The attribute to configure is `node['imply-platform']['zookeeper']`.

### Metadata HA Cluster

Similarly, you need also a SQL server (MariaDB or PostgreSQL) to hold Druid
metadata.

This is not in the scope of this cookbook but if you need one, you should
consider using [Galera Platform][galera-platform]. Galera is master-master
replication system which can be applied to both MariaDB or PostgreSQL. This
assures a truly fault-tolerant setting for Druid.

The configuration of database hosts use search and is done similarly as for
Imply hosts, _ie_ with a static list of hostnames or by using a search on
a role. The attribute to configure is `node['imply-platform']['database']`.

### Java

By default, this cookbook installs *openjdk* from the official repositories
*(openjdk-headless 8 on centos 7)* just before starting the service. You can
change this behavior by setting `node['imply-platform']['java']` to `""`, or
choose your package by setting the package name in
`node['imply-platform']['java'][node[:platform]]`.

### Test

This cookbook is fully tested through the installation of the full platform
in docker hosts. This uses kitchen, docker and some monkey-patching.

If you run `kitchen list`, you will see many suites:

- data-volume-imply-centos-7 (to have a shared /data)
- zookeeper-imply-centos-7
- galera-imply-centos-7
- master-imply-1-centos-7
- master-imply-2-centos-7
- data-imply-1-centos-7
- data-imply-2-centos-7
- query-imply-1-centos-7
- query-imply-2-centos-7
- client-imply-1-centos-7

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

Include search, user, install, nodejs (only for client nodes), database (except
for client only nodes), config, systemd and service recipes (in that order).

### search

Performs all the required searches and store the results in
`node.run_state['imply-platform']`. For instance, it defines a boolean for each
Imply role so they can be used by other recipes.

### user

Create necessary user and group which will run Imply services.

### nodejs

Install nodejs through NodeJS official repository.

### install

Install Imply distribution from official tar.gz archive.

### database

Configure the database needed by the metadata service.

### config

Configure all Imply services.

### systemd

Install and configure Systemd services.

### service

Configure services (enable, start and restart).

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
