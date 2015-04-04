# encoding: utf-8
if RUBY_ENGINE == 'rbx'
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

require 'rom-event_store'

class Integer
  # Just for readability
  def seconds
    self
  end
end

RSpec::Matchers.define :have do |expectation|
  match do |actual|
    if @before
      Timeout.timeout @before do
        loop do
          break if actual.to_a.size >= expectation
          sleep(0.1)
        end
      end
    end

    expect(actual.to_a.size).to be(expectation)
  end

  chain(:events) { }

  chain :before do |seconds|
    @before = seconds
  end
end

RSpec::Matchers.define :contain do |expectation|
  match do |actual|
    actual.to_a.zip(expectation).each do |item, original|
      expect(item).to include(original)
    end
  end
end
