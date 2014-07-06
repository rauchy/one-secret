require './lib/one_secret'

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/pride'

require 'rspec/mocks'
require 'minitest/autorun'
require 'rspec/mocks'

module MinitestRSpecMocksIntegration
  include ::RSpec::Mocks::ExampleMethods

  def before_setup
    ::RSpec::Mocks.setup
    super
  end

  def after_teardown
    super
    ::RSpec::Mocks.verify
  ensure
    ::RSpec::Mocks.teardown
  end
end

Minitest::Spec.send(:include, MinitestRSpecMocksIntegration)
