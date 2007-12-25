require File.dirname(__FILE__) + '/../test_helper'

class AllowanceTaskTest < Test::Unit::TestCase
  fixtures :allowance_tasks, :groups, :users, :categories, :money_accounts

  def test_lookup
    t=AllowanceTask.find :first, :order => ['id']
    assert_equal "Do Stuff", t.name
    assert_equal "Do all the stuff.", t.description
    assert_equal users(:dustin), t.creator
    assert_equal users(:aaron), t.owner
    assert_equal 7, t.frequency
    assert_in_delta(0.25, t.value, 2 ** -20)
    assert_equal money_accounts(:one), t.from_account
    assert_equal money_accounts(:three), t.to_account
    assert_equal categories(:one), t.from_category
    assert_equal categories(:three), t.to_category
    assert_equal false, t.deleted
  end
end
