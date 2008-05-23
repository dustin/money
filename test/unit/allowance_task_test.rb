require File.dirname(__FILE__) + '/../test_helper'

class AllowanceTaskTest < Test::Unit::TestCase
  include AuthenticatedTestHelper

  fixtures :allowance_tasks, :groups, :users, :categories, :money_accounts, :group_user_map

  def test_lookup
    t=AllowanceTask.find :first, :order => ['id']
    assert_equal "Do Stuff", t.name
    assert_equal "Do all the stuff.", t.description
    assert_equal users(:quentin), t.creator
    assert_equal users(:aaron), t.owner
    assert_equal 7, t.frequency
    assert_in_delta 0.25, t.value, 2 ** -20
    assert_equal money_accounts(:three), t.from_account
    assert_equal money_accounts(:one), t.to_account
    assert_equal categories(:three), t.from_category
    assert_equal categories(:one), t.to_category
    assert_equal false, t.deleted
  end

  def test_available
    assert_equal [1,3], available_ids
  end

  def test_weekly_value_daily
    t=AllowanceTask.new :frequency => 1, :value => 0.50
    assert_in_delta 3.5, t.weekly_value, 2 ** -20
  end

  def test_weekly_value_weekly
    t=AllowanceTask.new :frequency => 7, :value => 0.50
    assert_in_delta 0.5, t.weekly_value, 2 ** -20
  end

  def test_weekly_value_bi_daily
    t=AllowanceTask.new :frequency => 2, :value => 0.50
    assert_in_delta 1.75, t.weekly_value, 2 ** -20
  end

  def test_weekly_value_fortnightly
    t=AllowanceTask.new :frequency => 14, :value => 0.50
    assert_in_delta 0.25, t.weekly_value, 2 ** -20
  end

  def test_creation
    t=AllowanceTask.new
    t.name = 'Test'
    t.description = 'test'
    t.creator = users(:quentin)
    t.owner = users(:aaron)
    t.frequency = 3
    t.value = 3.99
    t.from_account = money_accounts(:three)
    t.from_category = categories(:three)
    t.to_account = money_accounts(:one)
    t.to_category = categories(:one)
    assert t.save
  end

  def test_invalid_amount
    t=AllowanceTask.new
    t.name = 'Test'
    t.description = 'test'
    t.creator = users(:quentin)
    t.owner = users(:aaron)
    t.frequency = 3
    t.value = -3.99
    t.from_account = money_accounts(:three)
    t.from_category = categories(:three)
    t.to_account = money_accounts(:one)
    t.to_category = categories(:one)
    assert !t.valid?
    assert_equal "should be greater than zero", t.errors[:value]
  end

  def test_invalid_frequency
    t=AllowanceTask.new
    t.name = 'Test'
    t.description = 'test'
    t.creator = users(:quentin)
    t.owner = users(:aaron)
    t.frequency = 0
    t.value = 3.99
    t.from_account = money_accounts(:three)
    t.from_category = categories(:three)
    t.to_account = money_accounts(:one)
    t.to_category = categories(:one)
    assert !t.valid?
    assert_equal "should be greater than zero", t.errors[:frequency]
  end

  def test_creation_inaccessible_creator_account
    t=AllowanceTask.new
    t.name = 'Test'
    t.description = 'test'
    t.creator = users(:aaron)
    t.owner = users(:quentin)
    t.frequency = 3
    t.value = 3.99
    t.from_account = money_accounts(:three)
    t.from_category = categories(:three)
    t.to_account = money_accounts(:one)
    t.to_category = categories(:one)
    assert !t.valid?
    assert_equal "aaron has no permission to account 3", t.errors[:creator]
  end

  def test_creation_inaccessible_recipient_account
    t=AllowanceTask.new
    t.name = 'Test'
    t.description = 'test'
    t.creator = users(:quentin)
    t.owner = users(:aaron)
    t.frequency = 3
    t.value = 3.99
    t.from_account = money_accounts(:one)
    t.from_category = categories(:one)
    t.to_account = money_accounts(:three)
    t.to_category = categories(:three)
    assert !t.valid?
    assert_equal "aaron has no permission to account 3", t.errors[:owner]
  end

  def test_creation_invalid_categories
    t=AllowanceTask.new
    t.name = 'Test'
    t.description = 'test'
    t.creator = users(:quentin)
    t.owner = users(:aaron)
    t.frequency = 3
    t.value = 3.99
    t.from_account = money_accounts(:three)
    t.from_category = categories(:two)
    t.to_account = money_accounts(:one)
    t.to_category = categories(:three)
    assert !t.valid?
    assert_equal ["2 does not belong to account 3", "3 does not belong to account 1"], t.errors[:category]
  end

  # Perform a task, make sure money gets transferred and the task is no longer available.
  def test_perform
    assert_difference 'MoneyTransaction.count', 2 do
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
