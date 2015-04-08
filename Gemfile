source 'https://rubygems.org'

# Specify your gem's dependencies in rom-event_store.gemspec
gemspec

group :test do
  gem 'inflecto'
  gem 'rom', git: 'https://github.com/rom-rb/rom.git', branch: 'master'
  gem 'codeclimate-test-reporter', require: false
end

group :tools do
  gem 'rubocop', '~> 0.28.0'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-rubocop'
end
