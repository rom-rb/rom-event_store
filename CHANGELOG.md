## v0.0.7 - 2016-02-10

### Changed

* Updated to ROM 1.0 (hecrj)
* Renamed command `Append` to `Create`

[Compare v0.0.6...v0.0.7](https://github.com/rom-rb/rom-event_store/compare/v0.0.6...v0.0.7)

## v0.0.6 - 2016-02-10

### Changed

* Updated to ROM 0.8.0 (solnic & hecrj)

[Compare v0.0.5...v0.0.6](https://github.com/rom-rb/rom-event_store/compare/v0.0.5...v0.0.6)

## v0.0.5 - 2015-04-08

### Added

* Stream identifier to event data
* Development section to README
* Executable `bin/init-es` that prepares the Event Store for running specs

### Changed

* Official `rom` repository! Yay!

### Fixed

* Event dehydration on subscriptions

[Compare v0.0.4...v0.0.5](https://github.com/rom-rb/rom-event_store/compare/v0.0.4...v0.0.5)

## v0.0.4 - 2015-04-05

### Added

* Asynchronous subscriptions to relations (live and catchup)
* Partial reads from a relation (batch reads)
* TCP driver as an own gem: [estore](https://github.com/eventstore-rb/estore) (help wanted!!)
* `estore` gem updated (general refactoring and error handling improved. WIP)

[Compare v0.0.3...v0.0.4](https://github.com/rom-rb/rom-event_store/compare/v0.0.3...v0.0.4)

## v0.0.3 - 2015-04-01

### Added

* [TCP driver](https://github.com/mathieuravaux/eventstore-ruby) to connect and read events from the Event Store

[Compare v0.0.2...v0.0.3](https://github.com/rom-rb/rom-event_store/compare/v0.0.2...v0.0.3)

## v0.0.2 - 2015-03-31

### Added

* Relation through AtomPub API using HTTP
* Read all events from a relation
* Append events to a relation

[Compare v0.0.1...v0.0.2](https://github.com/rom-rb/rom-event_store/compare/v0.0.1...v0.0.2)

## v0.0.1 - 2015-03-30

Initial release
