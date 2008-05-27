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
    login_as :quentin
    get :recent
    assert_response :success
    assert_equal 4, assigns['transactions'].length
  end

  def test_users
    login_as :quentin
    get :users
    assert_response :success
    assert_equal [1, 2], assigns['users'].map(&:id).sort
  end

  def test_reset_password_form
    login_as :quentin
    get :reset_password
    assert_response :success
    assert_template 'reset_password_form'
  end

  def test_reset_password
    assert User.authenticate('aaron', 'test')
    login_as :quentin
    post :reset_password, :user => 'aaron'
    assert_response :success
    assert_template "reset_password"
    assert assigns["newpass"]

    assert !User.authenticate('aaron', 'test')
    assert User.authenticate('aaron', assigns["newpass"])
  end

  def test_reset_not_admin
    login_as :aaron
    post :reset_password, :user => 'quentin'
    assert_response :success
    assert_template 'report/access_denied'
    assert User.authenticate('quentin', 'test'), 'Password changed!'
  end

  def test_reset_not_logged_in
    post :reset_password, :user => 'quentin'
    assert_redirected_to login_path
    assert User.authenticate('quentin', 'test'), 'Password changed!'
  end

  def test_rjs_delete
    login_as :quentin
    assert_difference 'MoneyTransaction.count', -1 do
      xhr :post, :delete, :id => 1, :format => 'js'
    end
    assert_response :success
  end

  def test_rjs_undelete
    login_as :quentin
    assert_difference 'MoneyTransaction.count' do
      xhr :post, :undelete, :id => 3, :format => 'js'
    end
    assert_response :success
  end

  def test_new_user_form
    login_as :quentin
    get :new_user
    assert_response :success
    assert_template 'adm/new_user'
    assert assigns['groups']
    assert assigns['user']
  end

  def test_new_user
    login_as :quentin
    assert_difference 'User.count' do
      post :new_user, :user => {:login => 'dtest', :name => 'D Test', :email => 'dtest@spy.net'},
        :group => {1 => 1, 2 => 1}
    end
    u=User.find_by_login 'dtest'
    assert_equal [1, 2], u.groups.map(&:id).sort
    assert_response :success
    assert_template 'adm/reset_password'
    assert assigns['groups']
    assert assigns['user']
    assert assigns['newpass']
  end

  def test_set_groups_form
    login_as :quentin
    get :set_groups
    assert_response :success
    assert_template 'adm/set_groups'
    assert assigns['groups']
    assert assigns['user_gids']
  end

  def test_set_groups_form_with_arg
    login_as :quentin
    get :set_groups, :user => 'aaron'
    assert_response :success
    assert_template 'adm/set_groups'
    assert assigns['groups']
    assert assigns['user_gids']
  end

  def test_set_groups
    login_as :quentin
    assert_equal [1], User.find_by_login('aaron').groups.map(&:id).sort
    post :set_groups, :user => 'aaron', :group => { 1 => 0, 2 => 1 }
    assert_equal [2], User.find_by_login('aaron').groups.map(&:id).sort
    assert_response :success
    assert_template 'adm/finished_set_groups'
    assert assigns['groups']
    assert assigns['user']
    assert assigns['user_gids']
  end

  def test_set_groups_empty
    login_as :quentin
    assert_equal [1], User.find_by_login('aaron').groups.map(&:id).sort
    post :set_groups, :user => 'aaron'
    assert_equal [], User.find_by_login('aaron').groups.map(&:id).sort
    assert_response :success
    assert_template 'adm/finished_set_groups'
    assert assigns['groups']
    assert assigns['user']
    assert assigns['user_gids']
  end

  def test_set_groups_invalid_user
    login_as :quentin
    post :set_groups, :user => 'nobody', :group => { 2 => 1 }
    assert_response :success
    assert_template 'adm/set_groups'
    assert assigns['groups']
    assert assigns['user_gids']
  end

end
