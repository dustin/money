require File.dirname(__FILE__) + '/../test_helper'
require 'acct_controller'

# Re-raise errors caught by the controller.
class AcctController; def rescue_action(e) raise e end; end

class AcctControllerTest < Test::Unit::TestCase
  include AuthenticatedTestHelper

  fixtures :users, :groups, :money_accounts, :categories

  def setup
    @controller = AcctController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_recent
    login_as :dustin
    get :recent
    assert_response :success
    assert_equal 4, assigns['transactions'].length
  end

  def test_index
    login_as :dustin
    get :index
    assert_response :success
    assert_equal users(:dustin).groups, assigns['groups']
  end

  def test_transactions_all
    login_as :dustin
    get :transactions_all, {:id => 1}
    assert_response :success
    assert_equal 3, assigns['transactions'].length
    assert_in_delta -18.45, assigns['txn_sum'], 2 ** -20
    assert_in_delta -5.0, assigns['rec_sum'], 2 ** -20
    assert_in_delta -13.45, assigns['unrec_sum'], 2 ** -20
  end

  def test_transactions
    login_as :dustin
    get :transactions, {:id => 1}
    assert_response :success
    assert_equal 2, assigns['transactions'].length
    assert_in_delta -18.45, assigns['txn_sum'], 2 ** -20
    assert_in_delta -5.0, assigns['rec_sum'], 2 ** -20
    assert_in_delta -13.45, assigns['unrec_sum'], 2 ** -20
  end

  def test_transactions2
    login_as :dustin
    get :transactions, {:id => 2}
    assert_response :success
    assert_equal 1, assigns['transactions'].length
    assert_in_delta 500.13, assigns['txn_sum'], 2 ** -20
    assert_in_delta 0.0, assigns['rec_sum'], 2 ** -20
    assert_in_delta 500.13, assigns['unrec_sum'], 2 ** -20
  end

  def test_transactions3
    login_as :dustin
    get :transactions, {:id => 3}
    assert_response :success
    assert_equal 0, assigns['transactions'].length
    assert_in_delta 0.0, assigns['txn_sum'], 2 ** -20
    assert_in_delta 0.0, assigns['rec_sum'], 2 ** -20
    assert_in_delta 0.0, assigns['unrec_sum'], 2 ** -20
  end

  def test_new_form
    login_as :dustin
    get :new, {:id => 1}
    assert_response :success
    assert assigns['today']
    assert assigns['current_acct']
    assert assigns['txn']
  end

  def test_new_withdrawal
    new_test -19.99, {:id => 1, :withdraw => 1, :money_transaction => {
      :ds => '2007-11-11', :descr => 'Test Transaction',
      :amount => 19.99, :category_id => 2}}
  end

  def test_new_deposit
    new_test 19.99, {:id => 1, :withdraw => 0, :money_transaction => {
      :ds => '2007-11-11', :descr => 'Test Transaction',
      :amount => 19.99, :category_id => 2}}
  end

  private

    def new_test(offset_expectation, args)
      login_as :dustin
      acct = MoneyAccount.find 1
      old_balance = acct.balance
      post :new, args
      assert_response :redirect
      # Check out the latest transaction
      txn = MoneyTransaction.find assigns['new_id']
      assert_in_delta offset_expectation, txn.amount, 2 ** -20
      assert_in_delta old_balance + offset_expectation, acct.balance, 2 ** -20
    end
end
