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

  def test_new_account_form
    login_as :quentin
    get :new
    assert_response :success
    assert_equal users(:quentin).groups, assigns(:groups)
  end

  def test_new_account
    login_as :quentin
    assert_difference 'MoneyAccount.count' do
      post :create, :money_account => { :name => 'Test Acct',
        :group_id => groups(:one).id }
      assert_redirected_to home_path
    end
  end

  def test_new_account_invalid_group
    login_as :quentin
    assert_no_difference 'MoneyAccount.count' do
      assert_raises(ActiveRecord::RecordNotFound) do
        post :create, :money_account => { :name => 'Test Acct',
          :group_id => 2888533 }
      end
    end
  end

  def test_new_account_illegal_access
    login_as :aaron
    assert_no_difference 'MoneyAccount.count' do
      assert_raises(RuntimeError) do
        post :create, :money_account => { :name => 'Test Acct',
          :group_id => groups(:two).id }
      end
    end
  end

end
