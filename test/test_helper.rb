ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  include Warden::Test::Helpers
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #fixtures :all

  # Add more helper methods to be used by all tests here...
  def login_user(user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd'))
    login_as(user, scope: 'user')
    user
  end
end
