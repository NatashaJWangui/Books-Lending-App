ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Load all fixtures from test/fixtures/*.yml for all tests
    fixtures :all

    # Disable referential integrity before loading fixtures
    setup do
      ActiveRecord::Base.connection.disable_referential_integrity do
        # This block ensures foreign key constraints are ignored
      end
    end

    # Add more helper methods to be used by all tests here...
  end
end
