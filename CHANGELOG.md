# Version History

## 0.1.0.5

* Update depends native-dumper==0.3.5.2
* Update depends pgpack-dumper==0.3.5.2
* Update docs directory
* Improve DQ check column log output info

## 0.1.0.4

* Update depends native-dumper==0.3.5.1
* Update depends pgpack-dumper==0.3.5.1
* Fix chunk_query function

## 0.1.0.3

* Update README.md
* Update docs directory
* Update depends native-dumper==0.3.5.0
* Update depends pgpack-dumper==0.3.5.0
* Update depends dbhose-utils==0.0.2.5

## 0.1.0.2

* Add depends dbhose-utils==0.0.2.4
* Add documentation link
* Delete OLD_DOCS.md

## 0.1.0.1

* Update depends native-dumper==0.3.4.9
* Update depends pgpack-dumper==0.3.4.8
* Update README.md
* Change DQ output message for check column sum

## 0.1.0.0

* Update depends native-dumper==0.3.4.8
* Update README.md
* Change project status to Beta

## 0.0.4.4

* Update depends pgpack-dumper==0.3.4.7
* Fix pgpack array read function on unix systems
* Fix install on unix systems

## 0.0.4.3

* Update depends pgpack-dumper==0.3.4.6

## 0.0.4.2

* Update depends pgpack-dumper==0.3.4.5
* Fix unpack requires a buffer of 4 bytes for unix systems

## 0.0.4.1

* Update depends pgpack-dumper==0.3.4.4

## 0.0.4.0

* Update depends native-dumper==0.3.4.7
* Update depends pgpack-dumper==0.3.4.3
* Update setuptools to latest version

## 0.0.3.7

* Update depends native-dumper==0.3.4.6
* Update depends pgpack-dumper==0.3.4.1

## 0.0.3.6

* Update depends native-dumper==0.3.4.5

## 0.0.3.5

* Update depends native-dumper==0.3.4.4

## 0.0.3.4

* Update depends native-dumper==0.3.4.3
* Update depends pgpack-dumper==0.3.4.2

## 0.0.3.3

* Update depends native-dumper==0.3.4.2

## 0.0.3.2

* Update depends native-dumper==0.3.4.1

## 0.0.3.1

* Update depends pgpack-dumper==0.3.4.1
* Improve invalid byte sequence for encoding "UTF8": 0x00

## 0.0.3.0

* Update depends native-dumper==0.3.4.0
* Update depends pgpack-dumper==0.3.4.0
* Add auto convert String/FixedString(36) from Clickhouse data to Postgres uuid
* Fix docs show logo

## 0.0.2.8

* Update depends pgpack-dumper==0.3.3.6

## 0.0.2.7

* Fix clickhouse replace partition query
* Improve query_part() function
* Update depends native-dumper==0.3.3.3
* Fix LOGO letters

## 0.0.2.6

* Update depends pgpack-dumper==0.3.3.5
* Refactor from_airflow initialization
* Fix Destination Table diagram

## 0.0.2.5

* Update depends pgpack-dumper==0.3.3.4
* Add docs directory to project

## 0.0.2.4

* Update depends native-dumper==0.3.3.2
* Update depends pgpack-dumper==0.3.3.3
* Add gc collect after write destination table

## 0.0.2.3

* Update depends pgpack-dumper==0.3.3.2
* Fix write_between diagram for Postgres/Greenplum objects

## 0.0.2.2

* Fix include_package_data

## 0.0.2.1

* Add MoveMethod.rewrite for full rewrite table with new data
* Add query_part function
* Change filter_by initialization list to string
* Fix Clickhouse MoveMethod.delete
* Improve execute custom query & MoveMethod operations
* Update depends native-dumper==0.3.3.1
* Update depends pgpack-dumper==0.3.3.1

## 0.0.2.0

* Update depends native-dumper==0.3.3.0
* Update depends pgpack-dumper==0.3.3.0
* Update README.md
* Add create partition into postgres and greenplum ddl queryes
* Improve delete.sql for greenplum and postgres

## 0.0.1.0

* Update depends native-dumper==0.3.2.3
* Update depends pgpack-dumper==0.3.2.2
* Move old README.md into OLD_DOCS.md
* Create new README.md
* Delete dbhose-utils from depends
* Rename repository dbhose -> dbhose_airflow

## 0.0.0.1

First version of the library dbhose_airflow
