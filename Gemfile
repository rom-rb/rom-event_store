source 'https://rubygems.org'

# Specify your gem's dependencies in rom-eventstore.gemspec
gemspec

group :test do
  gem 'rom', git: 'https://github.com/rom-rb/rom.git', branch: 'master'
  gem 'rspec', '~> 3.1'
  gem 'codeclimate-test-reporter', require: false
end

group :tools do
  gem 'rubocop'

  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-rubocop'
end
