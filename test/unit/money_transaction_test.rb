require File.dirname(__FILE__) + '/../test_helper'

class MoneyTransactionTest < Test::Unit::TestCase
  fixtures :money_transactions, :money_accounts, :money_categories,
    :money_users, :money_groups

  def test_transaction_list
    assert_equal(3, MoneyTransaction.find(:all).length)
  end

  def test_transaction_list_for_account
    assert_equal(2, MoneyAccount.find(1).transactions.length)
  end

  def test_deletion
    t=MoneyTransaction.find(1)
    t.destroy
    assert_raise(ActiveRecord::RecordNotFound) do
      MoneyTransaction.find(1)
    end

    td=MoneyTransaction.find_with_deleted(1)
    td.deleted_at = nil
    td.save
    
    assert_equal(td, MoneyTransaction.find(1))
  end

  def test_creation
    t=MoneyTransaction.new :user => MoneyUser.find(1),
      :account => MoneyAccount.find(1),
      :category => MoneyCategory.find(1),
      :descr => "Test Transaction", :amount => -9.99, :ds => Date.today,
      :ts => Time.now
    t.save
    
    assert_equal(t, MoneyTransaction.find(5))
  end

  def test_alt_creation
    a=MoneyAccount.find(1)
    t=a.transactions.create(:user => MoneyUser.find(1),
      :category => MoneyCategory.find(1),
      :descr => "Test transaction", :amount => -99.99, :ds => Date.today,
      :ts => Time.now)

    assert_equal(t, MoneyTransaction.find(5))
  end

  def test_summation
    s=MoneyTransaction.sum('amount', :conditions => 'money_account_id = 1')
    assert_in_delta(-18.45, s, 2 ** -20)
  end

  def test_summation2
    assert_in_delta(-18.45, MoneyAccount.find(1).transactions.sum('amount'), 2 ** -20)
  end
end
