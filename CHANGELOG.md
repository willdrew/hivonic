Hivonic Changelog
===

0.3.0
---
* Now cleans up views in addition to tables
* Tweaked HIVONIC_REGEXP default so it is a little less opinionated
* Fixed cleanup, so it no longer calls build_query repeatedly (also a performance improvement)

0.2.2
---
* Fixed issue with mock() instance that represents output from the subcommand in tests

0.2.1
---
* Tweaked HIVONIC_REGEXP env var's default value
* Tweaked .gitignore
* Fixed issue with cleanup command throwing a hive exception
* No longer outputs newline when subcommand output is nil or blank

0.2.0
---
* Added ability to specify match group index for regexp time capture
* Tweaked Gemfile and hivonic.gemspec
* Added unit tests and example files

0.1.0
---
* Basic functionality for cleaning up temporary tables
