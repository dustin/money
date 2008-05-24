require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :users

  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_password_change_form
    login_as :quentin
    get :edit
    assert_response :success
  end

  def test_password_change_bad_old_password
    login_as :quentin
    np = 'id28553'
    put :update, :user => { :current_password => 'crap',
      :password => np, :password_confirmation => np}
    assert_redirected_to edit_user_path(users(:quentin))
    assert_equal 'Incorrect old password.', flash[:error]
  end

  def test_password_change_new_pw_blank
    login_as :quentin
    np = ''
    put :update, :user => { :current_password => 'test',
      :password => np, :password_confirmation => np}
    assert_redirected_to edit_user_path(users(:quentin))
    assert_match /Password confirmation.*blank/, flash[:error]
  end

  def test_password_change_password_no_match
    login_as :quentin
    np = 'i2938g82'
    put :update, :user => { :current_password => 'test',
      :password => np, :password_confirmation => np + "x"}
    assert_redirected_to edit_user_path(users(:quentin))
    assert_match /doesn't match confirmation/, flash[:error]
  end

  def test_password_change_success
    login_as :quentin
    np = 'i2938g82'
    put :update, :user => { :current_password => 'test',
      :password => np, :password_confirmation => np}
    assert_redirected_to home_path
    assert_equal 'Password changed.', flash[:info]
    assert User.authenticate('quentin', np)
  end

  protected
    def create_user(options = {})
      post :create, :user => { :login => 'quire', :email => 'quire@example.com',
        :password => 'quire', :password_confirmation => 'quire' }.merge(options)
    end
end
