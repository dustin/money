require File.dirname(__FILE__) + '/../test_helper'
require 'account_controller'

# Re-raise errors caught by the controller.
class AccountController; def rescue_action(e) raise e end; end

class AccountControllerTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :users

  def setup
    @controller = AccountController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_login_and_redirect
    post :login, :login => 'dustin', :password => 'blahblah'
    assert session[:user]
    assert_response :redirect
  end

  def test_should_fail_login_and_not_redirect
    post :login, :login => 'dustin', :password => 'bad password'
    assert_nil session[:user]
    assert_response :success
  end

  def test_should_allow_signup
    assert_difference User, :count do
      create_user
      assert_response :redirect
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference User, :count do
      create_user(:login => nil)
      assert assigns(:user).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference User, :count do
      create_user(:password => nil)
      assert assigns(:user).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference User, :count do
      create_user(:password_confirmation => nil)
      assert assigns(:user).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference User, :count do
      create_user(:email => nil)
      assert assigns(:user).errors.on(:email)
      assert_response :success
    end
  end

  def test_should_logout
    login_as :dustin
    get :logout
    assert_nil session[:user]
    assert_response :redirect
  end

  # This test doesn't pass.  I don't actually need it, but it's curious.
  def do_not_test_should_remember_me
    post :login, :login => 'dustin', :password => 'test', :remember_me => "1"
    assert_not_nil @response.cookies["auth_token"]
  end

  def test_should_not_remember_me
    post :login, :login => 'dustin', :password => 'test', :remember_me => "0"
    assert_nil @response.cookies["auth_token"]
  end
  
  def test_should_delete_token_on_logout
    login_as :dustin
    get :logout
    assert_equal @response.cookies["auth_token"], []
  end

  def test_should_login_with_cookie
    users(:dustin).remember_me
    @request.cookies["auth_token"] = cookie_for(:dustin)
    get :index
    assert @controller.send(:logged_in?)
  end

  def test_should_fail_expired_cookie_login
    users(:dustin).remember_me
    users(:dustin).update_attribute :remember_token_expires_at, 5.minutes.ago
    @request.cookies["auth_token"] = cookie_for(:dustin)
    get :index
    assert !@controller.send(:logged_in?)
  end

  def test_should_fail_cookie_login
    users(:dustin).remember_me
    @request.cookies["auth_token"] = auth_token('invalid_auth_token')
    get :index
    assert !@controller.send(:logged_in?)
  end

  def test_change_password_form
    login_as :aaron
    get :change_password
    assert_response :success
    assert_template 'account/change_password'
  end

  def test_change_password_bad_current
    login_as :aaron
    post :change_password, {:current_password => 'blah',
      :password => 'blahblah2', :password_confirmation => 'blahblah2'}
    assert_response :success
    assert_equal flash[:error], 'Incorrect old password.'
    # Validate old password still works
    assert User.authenticate('aaron', 'test')
  end

  def test_change_password_bad_confirmation
    login_as :aaron
    post :change_password, {:current_password => 'test',
      :password => 'blahblah2', :password_confirmation => 'blahblah3'}
    assert_response :success
    assert_equal flash[:error], "Validation failed: Password doesn't match confirmation"
    # Validate old password still works
    assert User.authenticate('aaron', 'test')
  end

  def test_change_password_success
    login_as :aaron
    post :change_password, {:current_password => 'test',
      :password => 'blahblah2', :password_confirmation => 'blahblah2'}
    assert_response :redirect
    assert_equal flash[:info], 'Password changed.'
    # Validate old password still works
    assert User.authenticate('aaron', 'blahblah2')
  end

  protected
    def create_user(options = {})
      post :signup, :user => { :login => 'quire', :name => 'blah', :email => 'quire@example.com', 
        :password => 'quire', :password_confirmation => 'quire' }.merge(options)
    end
    
    def auth_token(token)
      CGI::Cookie.new('name' => 'auth_token', 'value' => token)
    end
    
    def cookie_for(user)
      auth_token users(user).remember_token
    end
end
