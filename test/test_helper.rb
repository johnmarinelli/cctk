require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include ApplicationHelper

  # http://wholemeal.co.nz/blog/2011/04/06/assert-difference-with-multiple-count-values/
  def assert_differences(expression_array, message = nil, &block)
    b = block.send :binding 

    # map over [["Model.count", x], ["Model2.count", y]]
    # and evaluate expressions in this context
    before = expression_array.map { |expr| eval expr[0], b }

    yield 

    # go back over each expression
    # re evaluate and assert difference is accurate
    expression_array.each_with_index do |pair, i|
      expr = pair[0]
      diff = pair[1]

      after = eval expr, b

      error = "#{expr.inspect} didn't change by #{diff}"
      error = "#{message}\n#{error}" if message

      assert_equal before[i] + diff, after, error

    end
  end

  def is_logged_in?
    !session[:user_id].nil?
  end

  def log_in_as(user)
    session[:user_id] = user.id
  end

  def log_out(user)
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
    session.delete :user_id
    session[:user_id] = nil
  end
end

class ActionDispatch::IntegrationTest
  # integration test helper
  def log_in_as(user, password, remember_me: '1')
    post login_path, params: { session: { email: user.email, password: password, remember_me: remember_me } }
  end
end
