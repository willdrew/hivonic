hivonic
========

Tonic oriented utilities for hive (Hive + Tonic => hivonic)

This tool requires tmp hive tables to include timestamp as part of the table name by convention.

### Status
[![Build Status](https://travis-ci.org/willdrew/hivonic.svg?branch=master)](https://travis-ci.org/willdrew/hivonic)


## Shell Environment Variables
- $HIVONIC_HIVE_OPTS
    * Options passed to the hive client
    * Defaults to '-S' # Silent
- $HIVONIC_REGEXP
    * This is the regexp used to match tables and capture time from name
    * Defaults to '\A(tmp|view)[a-z|_|0-9]+_(\d{14})\Z'
- $HIVONIC_TIME_FORMAT
    * This is the time format used to parse the timestamp from the table name
    * Defaults to '%Y%m%d%H%M%S'
- $HIVONIC_TIME_GROUP_INDEX
    * Ability to specify match group index for regexp time capture
    * Defaults to '2'
- $HIVONIC_TTL
    * This is the Time-To-Live for Hive temporary tables
    * Defaults to '86400' (24 hours)


## Hivonic Commands
- list __db__
    * Lists all tmp hive tables that match regexp and are expired
- rm __db__ __table__
    * Removes specified table from specified db
- cleanup __db__
    * Cleans up (removes) all tmp hive tables that match regexp and are expired


### Example Usages
``` shell
hivonic list default
hivonic cleanup default
hivonic rm default sometimestamp_sometable
```


Credit [Ethan Rowe ](https://github.com/ethanrowe) for the original command handler technique in [hadupils](https://github.com/ethanrowe/hadupils).
