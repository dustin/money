require File.dirname(__FILE__) + '/../test_helper'

class AllowanceTaskTest < Test::Unit::TestCase
  fixtures :allowance_tasks, :groups, :users, :categories, :money_accounts

  def test_lookup
    t=AllowanceTask.find :first
    assert_equal("Do Stuff", t.name)
    assert_equal("Do all the stuff.", t.description)
    assert_equal(User.find(1), t.creator)
    assert_equal(User.find(2), t.owner)
    assert_equal(7, t.frequency)
    assert_in_delta(0.25, t.value, 2 ** -20)
    assert_equal(MoneyAccount.find(1), t.from_account)
    assert_equal(MoneyAccount.find(3), t.to_account)
    assert_equal(Category.find(1), t.from_category)
    assert_equal(Category.find(3), t.to_category)
    assert_equal(false, t.deleted)
  end
end
