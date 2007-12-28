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

  def test_recent
    login_as :dustin
    get :recent
    assert_response :success
    assert_equal 4, assigns['transactions'].length
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


  def test_rjs_delete
    login_as :dustin
    assert_difference MoneyTransaction, :count, -1 do
      xhr :post, :delete, :id => 1
    end
    assert_response :success
  end

  def test_rjs_undelete
    login_as :dustin
    assert_difference MoneyTransaction, :count do
      xhr :post, :undelete, :id => 3
    end
    assert_response :success
  end

  def test_new_user_form
    login_as :dustin
    get :new_user
    assert_response :success
    assert_template 'adm/new_user'
    assert assigns['groups']
    assert assigns['user']
  end

  def test_new_user
    login_as :dustin
    assert_difference User, :count do
      post :new_user, :user => {:login => 'dtest', :name => 'D Test', :email => 'dtest@spy.net'},
        :group => {1 => 1, 2 => 2}
    end
    u=User.find_by_login 'dtest'
    assert_equal [1, 2], u.groups.map(&:id).sort
    assert_response :success
    assert_template 'adm/reset_password'
    assert assigns['groups']
    assert assigns['user']
    assert assigns['newpass']
  end

end
