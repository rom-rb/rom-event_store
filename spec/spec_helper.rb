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
    if @timeout
      Timeout.timeout @timeout do
        loop do
          break if actual.to_a.size >= expectation
          sleep(0.1)
        end
      end
    end

    expect(actual.to_a.size).to @bigger ? be >= expectation : be(expectation)
  end

  chain(:events) {}

  chain :before do |seconds|
    @timeout = seconds
  end

  chain :or_more do
    @bigger = true
  end
end

RSpec::Matchers.define :contain do |expectation|
  match do |actual|
    actual.to_a.zip(expectation).each do |item, original|
      expect(item).to include(original)
    end
  end
end
