require File.dirname(__FILE__) + '/../test_helper'
require 'api_controller'

# Re-raise errors caught by the controller.
class ApiController; def rescue_action(e) raise e end; end

class ApiControllerTest < Test::Unit::TestCase
  def setup
    @controller = ApiController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_acct_info
    result = invoke_layered :accountInfo, :getAccountInfo, 'dustin', 'blahblah'
    assert_equal %w(Group1 Group2), result.map(&:name).sort
  end

  def test_acct_info_aaron
    result = invoke_layered :accountInfo, :getAccountInfo, 'aaron', 'test'
    assert_equal %w(Group1), result.map(&:name).sort
  end

  def test_acct_info_bad_login
    assert_raise(RuntimeError) do
      result = invoke_layered :accountInfo, :getAccountInfo, 'dustin', 'blah'
    end
  end

end
