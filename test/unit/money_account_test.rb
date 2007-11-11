require File.dirname(__FILE__) + '/../test_helper'

class MoneyAccountTest < Test::Unit::TestCase
  fixtures :money_accounts, :groups

  def test_create
    a=MoneyAccount.new :name => "Test Account",
      :group => Group.find(1)
    a.save
    assert_equal(a, MoneyAccount.find(4))
  end

  def test_lookup
    assert_equal(Group.find(1), MoneyAccount.find(1).group)
  end
end
