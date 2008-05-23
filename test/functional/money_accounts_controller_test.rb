require File.dirname(__FILE__) + '/../test_helper'
require 'money_accounts_controller'

# Re-raise errors caught by the controller.
class MoneyAccountsController; def rescue_action(e) raise e end; end

class MoneyAccountsControllerTest < Test::Unit::TestCase
  include AuthenticatedTestHelper
  include AcctHelper

  fixtures :users, :groups, :money_accounts, :categories

  def setup
    @controller = MoneyAccountsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_unauthenticated_index
    get :index
    assert_redirected_to :controller => :session, :action => :new
  end

  def test_index
    login_as :quentin
    get :index
    assert_response :success
    assert_equal users(:quentin).groups, assigns['groups']
  end

end
