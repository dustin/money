require File.dirname(__FILE__) + '/../test_helper'

class MoneyAccountTest < Test::Unit::TestCase
  fixtures :money_accounts, :groups, :money_transactions

  def test_create
    a=MoneyAccount.new :name => "Test Account";
    a.group = groups(:one)
    a.save
    assert_equal(a, MoneyAccount.find(4))
  end

  def test_lookup
    assert_equal(groups(:one), MoneyAccount.find(1).group)
  end

  def test_transactions
    assert_equal(2, money_accounts(:one).transactions.length)
  end

  def test_transactions_from_get
    assert_equal(2, MoneyAccount.find(1).transactions.length)
  end

  def test_balance
    assert_equal(-18.45, money_accounts(:one).balance)
  end

  def test_balance_empty
    assert_equal(0, money_accounts(:three).balance)
  end
end
