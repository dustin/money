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
