# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rom/eventstore/version'

Gem::Specification.new do |spec|
  spec.name          = 'rom-eventstore'
  spec.version       = Rom::Eventstore::VERSION
  spec.authors       = ['Héctor Ramón', 'Lorenzo Arribas']
  spec.email         = ['hector0193@gmail.com', 'lorenzo.s.arribas@gmail.com']

  spec.summary       = %q{EventStore support for Ruby Object Mapper}
  spec.description   = spec.summary
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'
end
