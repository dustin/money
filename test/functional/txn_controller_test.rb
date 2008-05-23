require File.dirname(__FILE__) + '/../test_helper'
require 'txn_controller'

# Re-raise errors caught by the controller.
class TxnController; def rescue_action(e) raise e end; end

# Extra method for a test because I can't figure out how to pass arguments in.
def MoneyTransaction.count_reconciled
  MoneyTransaction.count :conditions => ['reconciled = ?', true]
end

class TxnControllerTest < Test::Unit::TestCase

  include AuthenticatedTestHelper
  include TxnHelper

  fixtures :users, :groups, :money_accounts, :categories, :money_transactions

  def setup
    @controller = TxnController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_transactions2
    login_as :quentin
    get :index, :acct_id => 2
    assert_response :success
    assert_equal 1, assigns['transactions'].length
    assert_in_delta 500.13, assigns['txn_sum'], 2 ** -20
    assert_in_delta 0.0, assigns['rec_sum'], 2 ** -20
    assert_in_delta 500.13, assigns['unrec_sum'], 2 ** -20
  end

  def test_transactions3
    login_as :quentin
    get :index, :acct_id => 3
    assert_response :success
    assert_equal 0, assigns['transactions'].length
    assert_in_delta 0.0, assigns['txn_sum'], 2 ** -20
    assert_in_delta 0.0, assigns['rec_sum'], 2 ** -20
    assert_in_delta 0.0, assigns['unrec_sum'], 2 ** -20
  end

  def test_transactions_all
    login_as :quentin
    get :index, :acct_id => 1, :which => 'all'
    assert_response :success
    assert_equal 3, assigns['transactions'].length
    assert_in_delta -18.45, assigns['txn_sum'], 2 ** -20
    assert_in_delta -5.0, assigns['rec_sum'], 2 ** -20
    assert_in_delta -13.45, assigns['unrec_sum'], 2 ** -20
  end

  def test_index
    login_as :quentin
    get :index, :acct_id => 1
    assert_response :success
    assert_equal 2, assigns['transactions'].length
    assert_in_delta -18.45, assigns['txn_sum'], 2 ** -20
    assert_in_delta -5.0, assigns['rec_sum'], 2 ** -20
    assert_in_delta -13.45, assigns['unrec_sum'], 2 ** -20
  end

  def test_unreconciled
    login_as :quentin
    get :index, :acct_id => 1, :which => 'unreconciled'
    assert_response :success
    assert_equal 1, assigns['transactions'].length
  end

  def test_new_form
    login_as :quentin
    get :new, {:acct_id => 1}
    assert_response :success
    assert assigns['today']
    assert assigns['current_acct']
    assert assigns['txn']
  end

  def test_new_withdrawal
    new_test -19.99, {:acct_id => 1, :withdraw => 1, :money_transaction => {
      :ds => '2007-11-11', :descr => 'Test Transaction',
      :amount => 19.99, :category_id => 2}}
  end

  def test_new_deposit
    new_test 19.99, {:acct_id => 1, :withdraw => 0, :money_transaction => {
      :ds => '2007-11-11', :descr => 'Test Transaction',
      :amount => 19.99, :category_id => 2}}
  end

  def test_descr_update
    login_as :quentin
    xhr :put, :update, :id => 1, :acct_id => 1, :f => 'descr', :value => 'Changed Stuff'
    assert_response :success
    assert_equal 'Changed Stuff', MoneyTransaction.find(1).descr
  end

  def test_unhandled_field
    login_as :quentin
    begin
      xhr :put, :update, :id => 1, :acct_id => 1, :f => 'somecrap', :value => 'Changed Stuff'
    rescue RuntimeError => e
      assert_equal 'Unhandled field:  somecrap', e.message
    end
  end

  def test_cat_update
    login_as :quentin
    xhr :put, :update, :id => 1, :acct_id => 1, :f => 'cat', :value => 'Cat2'
    assert_response :success
    assert_equal Category.find_by_name('Cat2'), MoneyTransaction.find(1).category
  end

  def test_rjs_reconcile
    login_as :quentin
    assert_difference 'MoneyTransaction.count_reconciled' do
      xhr :put, :update, :id => 1, :acct_id => 1, :f => 'reconciled', :value => 1
    end
    assert_response :success
  end

  def test_rjs_reconcile_four
    login_as :quentin
    assert_difference 'MoneyTransaction.count_reconciled' do
      xhr :put, :update, :acct_id => 1, :id => 4, :f => 'reconciled', :value => 1
    end
    assert_response :success
  end

  def test_rjs_unreconcile
    login_as :quentin
    assert_difference 'MoneyTransaction.count_reconciled', -1 do
      xhr :put, :update, :acct_id => 1, :id => 2, :f => 'reconciled', :value => 0
    end
    assert_response :success
  end

  def test_current_reconciled
    login_as :quentin
    xhr :get, :current_reconciled, :acct_id => 2
    assert_equal 2, assigns(:current_acct).id
  end

  private

    def new_test(offset_expectation, args)
      login_as :quentin
      acct = MoneyAccount.find 1
      old_balance = acct.balance
      post :create, args
      assert_response :redirect
      # Check out the latest transaction
      txn = MoneyTransaction.find assigns['new_id']
      assert_in_delta offset_expectation, txn.amount, 2 ** -20
      assert_in_delta old_balance + offset_expectation, acct.balance, 2 ** -20
    end

end
