require File.dirname(__FILE__) + '/../test_helper'
require 'adm_controller'

# Re-raise errors caught by the controller.
class AdmController; def rescue_action(e) raise e end; end

class AdmControllerTest < Test::Unit::TestCase
  include AuthenticatedTestHelper

  fixtures :users

  def setup
    @controller = AdmController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_reset_password
    assert User.authenticate('aaron', 'test')
    login_as :dustin
    post :reset_password, :user => 'aaron'
    assert_response :success
    assert_template "reset_password"
    assert assigns["newpass"]

    assert !User.authenticate('aaron', 'test')
    assert User.authenticate('aaron', assigns["newpass"])
  end

  def test_reset_not_admin
    login_as :aaron
    post :reset_password, :user => 'dustin'
  end

end
