Changelog
=========

4.0.0
-----

Main:

- chore: handover maintenance to make.org
- feat: update imply default version to 2.5.11
  + set default config from imply 2.5
  + enable sql in common config by default
  + adapt pivot config and fix tests
  + reduce memory used by each component
  + update to latest package
- feat: set default search sizes to 0
- feat: can set owner/group/mode for storage dirs
- feat: allow appending users to imply group
- feat: save default configs before modifying them
- fix: do not set retries if package\_retries is nil
- fix: better regexp in jvm config to allow more opt
- fix: java installation was difficult to deactivate

Tests:

- test: move driver config, set latest options
- test: require foodcritic & rubocop in Gemfile
- test: include .gitlab-ci.yml from test-cookbook
- test: merge each node into a full-stack one, at the end
- test: merge zk & galera and limit ram to 384mo
- test: reduce memory used with agressive settings
- test: increase database retries & give it more mem
- test: set indexing timeout to 600s
- test: add helper in "helper"-suite names
- test: set client suite aside to deactivate java
- test: add a retry opt on yum repository
- test: increase timeout for services
- test: retry indexing task multiple times

Misc:

- style(rubocop): fix %w-literals delimiters
- style(rubocop): fix heredoc & token offenses
- style(foodcritic): fix license & chef\_version
- style: use cookbook\_name macro everywhere
- docs: use karma for git format in contributing

3.0.0
-----

Main:

- Support imply 2.0.0+, break compatibility with previous versions

Tests:

- Use latest gitlab-ci template (20170117)
- Fix destroy after a fail occurs (mostly for CI)

2.0.0
-----

Main:

- Remove pivot from query, Stop using supervise
  + Remove pivot from query role (you probably want to install it elsewhere)
  + Stop using supervise script, use a systemd service for each component
- Create a new role 'client' to install pivot
  + Remove pivot recipe as it is no longer in use
  + Pivot config file can be configured with attributes
  + Tests for pivot, use journalctl instead of log file
  + Install nodejs for client
  + Do not connect to database if node is only a client
  + Small refacto in search recipe, factorize role searches
  + Simplify search attribute comments
- Log management
  + Configure log4j2 with log rotation
  + Move default log location to /var/opt/imply/log
- Add the possibility to add JVM options for all components
- Set root as owner of imply installation directory (except some config files)
- Deactivate emitter, and set it as debug by default
- Rationalize druid config, use global var/tmp dirs
- Improve auto-restart by correcly listing config templates
- Add database port (default: 3306)
- Remove dependency on yum (no need on recent chef)

Tests:

- Fix memory config for test cluster
- Use a docker volume to share /data between nodes
- Stop executing converge at verify phase in kitchen
- Wait for service in tests
- Use latest gitlab-ci template (20160914)
- Remove old disabled kitchen pivot suite

1.0.0
-----

- Initial version, supports centos 7
