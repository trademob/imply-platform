Changelog
=========

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
