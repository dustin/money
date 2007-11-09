require File.dirname(__FILE__) + '/../test_helper'

class MoneyGroupTest < Test::Unit::TestCase
  fixtures :money_groups, :money_group_user_map, :money_users,
    :money_accounts, :money_categories

  def test_create
    g=MoneyGroup.new :name => "Test Group"
    g.save
    assert_equal(g, MoneyGroup.find(3))
  end

  def test_list_users
    assert_equal([1, 2], MoneyGroup.find(1).users.map(&:id).sort)
  end

  def test_list_users2
    assert_equal([1], MoneyGroup.find(2).users.map(&:id).sort)
  end

  def test_list_accounts
    assert_equal([1, 2], MoneyGroup.find(1).accounts.map(&:id).sort)
  end

  def test_list_accounts2
    assert_equal([3], MoneyGroup.find(2).accounts.map(&:id))
  end
end
