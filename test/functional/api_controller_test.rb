require File.dirname(__FILE__) + '/../test_helper'
require 'api_controller'

# Re-raise errors caught by the controller.
class ApiController; def rescue_action(e) raise e end; end

class ApiControllerTest < Test::Unit::TestCase
  include AuthenticatedTestHelper

  def setup
    @controller = ApiController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_acct_info
    result = invoke_layered :accountInfo, :getAccountInfo, 'dustin', 'blahblah'
    assert_equal %w(Group1 Group2), result.map(&:name).sort
  end

  def test_acct_info_aaron
    result = invoke_layered :accountInfo, :getAccountInfo, 'aaron', 'test'
    assert_equal %w(Group1), result.map(&:name).sort
  end

  def test_acct_info_bad_login
    assert_raise(ApiHelper::AuthException) do
      result = invoke_layered :accountInfo, :getAccountInfo, 'dustin', 'blah'
    end
  end

  def test_txn_add
    assert_difference MoneyTransaction, :count, 3 do
      result = invoke_layered :transaction, :addTransactions,
        'dustin', 'blahblah', [
          TransactionStruct.new(:acctid => 1, :catid => 1, :amt => 1.93,
            :date => Date.today, :descr => 'Test transaction 1'),
          TransactionStruct.new(:acctid => 1, :catid => 2, :amt => -1.93,
            :date => Date.today, :descr => 'Got my payback for txn 1'),
          TransactionStruct.new(:acctid => 3, :catid => 3, :amt => -9.52,
            :date => Date.today, :descr => 'Something unrelated')
        ]
      assert_equal 0, result
    end
  end

  def test_txn_add_no_acct_auth
    assert_raise(ActiveRecord::RecordInvalid) do
      result = invoke_layered :transaction, :addTransactions,
        'aaron', 'test',
        [TransactionStruct.new(:acctid => 3, :catid => 3, :amt => 1.93,
            :date => Date.today, :descr => 'Test transaction 1')]
    end
  end

  def test_txn_cat_acct_mismatch
    assert_raise(ActiveRecord::RecordInvalid) do
      result = invoke_layered :transaction, :addTransactions,
        'dustin', 'blahblah',
        [TransactionStruct.new(:acctid => 3, :catid => 1, :amt => 1.93,
            :date => Date.today, :descr => 'Test transaction 1')]
    end
  end

end
