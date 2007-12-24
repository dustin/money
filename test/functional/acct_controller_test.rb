require File.dirname(__FILE__) + '/../test_helper'
require 'acct_controller'

# Re-raise errors caught by the controller.
class AcctController; def rescue_action(e) raise e end; end

class AcctControllerTest < Test::Unit::TestCase
  include AuthenticatedTestHelper
  include AcctHelper

  fixtures :users, :groups, :money_accounts, :categories

  def setup
    @controller = AcctController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    login_as :dustin
    get :index
    assert_response :success
    assert_equal users(:dustin).groups, assigns['groups']
  end

  # This test just validates the response is successful.
  def test_cat_list
    login_as :dustin
    get :cats_for_acct, {:id => 1}
    assert_response :success
    assert @response.body.include?('Cat1')
    assert @response.body.include?('Cat1')
    assert !@response.body.include?('Cat3')
  end

end
