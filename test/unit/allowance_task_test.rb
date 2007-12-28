require File.dirname(__FILE__) + '/../test_helper'

class AllowanceTaskTest < Test::Unit::TestCase
  include AuthenticatedTestHelper

  fixtures :allowance_tasks, :groups, :users, :categories, :money_accounts, :group_user_map

  def test_lookup
    t=AllowanceTask.find :first, :order => ['id']
    assert_equal "Do Stuff", t.name
    assert_equal "Do all the stuff.", t.description
    assert_equal users(:dustin), t.creator
    assert_equal users(:aaron), t.owner
    assert_equal 7, t.frequency
    assert_in_delta(0.25, t.value, 2 ** -20)
    assert_equal money_accounts(:three), t.from_account
    assert_equal money_accounts(:one), t.to_account
    assert_equal categories(:three), t.from_category
    assert_equal categories(:one), t.to_category
    assert_equal false, t.deleted
  end

  def test_available
    assert_equal [1,3], available_ids
  end

  # Perform a task, make sure money gets transferred and the task is no longer available.
  def test_perform
    assert_difference MoneyTransaction, :count, 2 do
      assert_equal [1,3], available_ids
      allowance_tasks(:three).perform!
      assert_equal [1], available_ids
    end
  end

  private
  
  def available_ids
    AllowanceTask.find_available(users(:aaron)).map(&:id).sort
  end
end
