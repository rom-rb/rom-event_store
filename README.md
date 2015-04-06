[gem]: https://rubygems.org/gems/rom-event_store
[travis]: https://travis-ci.org/rom-rb/rom-event_store
[gemnasium]: https://gemnasium.com/rom-rb/rom-event_store
[codeclimate]: https://codeclimate.com/github/rom-rb/rom-event_store
[inchpages]: http://inch-ci.org/github/rom-rb/rom-event_store

# ROM::EventStore

[![Gem Version](https://badge.fury.io/rb/rom-event_store.svg)][gem]
[![Build Status](https://travis-ci.org/rom-rb/rom-event_store.svg?branch=master)][travis]
[![Dependency Status](https://gemnasium.com/rom-rb/rom-event_store.png)][gemnasium]
[![Code Climate](https://codeclimate.com/github/rom-rb/rom-event_store/badges/gpa.svg)][codeclimate]
[![Test Coverage](https://codeclimate.com/github/rom-rb/rom-event_store/badges/coverage.svg)][codeclimate]
[![Inline docs](http://inch-ci.org/github/rom-rb/rom-event_store.svg?branch=master)][inchpages]

Event Store support for [Ruby Object Mapper](https://github.com/rom-rb/rom)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rom-event_store'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rom-event_store

## Development

You need to install [EventStore](http://geteventstore.com/) in order to be able
to run specs.

On OS X you can use [homebrew](http://brew.sh):

```
brew install homebrew/binary/EventStore
```

To start the server simply run:

```
eventstore
```

## Usage

See [spec/integration/adapter_spec.rb](spec/integration/adapter_spec.rb) for a sample usage.

## License

See [LICENSE](LICENSE) file.
