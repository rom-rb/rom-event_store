# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rom/event_store/version'

Gem::Specification.new do |spec|
  spec.name          = 'rom-event_store'
  spec.version       = ROM::EventStore::VERSION
  spec.authors       = ['Héctor Ramón', 'Lorenzo Arribas']
  spec.email         = ['hector0193@gmail.com', 'lorenzo.s.arribas@gmail.com']

  spec.summary       = 'Event Store support for Ruby Object Mapper'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/rom-rb/rom-event_store'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rom', '~> 0.6'
  spec.add_runtime_dependency 'estore', '~> 0.1.1'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.1'
end
