require File.dirname(__FILE__) + '/../test_helper'

class GroupTest < Test::Unit::TestCase
  fixtures :groups, :group_user_map, :users, :money_accounts, :categories,
    :money_transactions

  def test_create
    g=Group.new :name => "Test Group"
    g.save
    assert_equal(g, Group.find(4))
  end

  def test_list_users
    assert_equal([1, 2], groups(:one).users.map(&:id).sort)
  end

  def test_list_users2
    assert_equal([1], groups(:two).users.map(&:id).sort)
  end

  def test_list_accounts
    assert_equal([1, 2], groups(:one).accounts.map(&:id).sort)
  end

  def test_list_accounts2
    assert_equal([3], groups(:two).accounts.map(&:id))
  end

  def test_balance
    assert_equal(481.68, groups(:one).balance)
  end

  def test_balance_empty
    assert_equal(0, groups(:two).balance)
  end

  def test_balance_empty_group
    assert_equal(0, groups(:empty).balance)
  end
end
