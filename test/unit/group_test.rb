require File.dirname(__FILE__) + '/../test_helper'

class GroupTest < Test::Unit::TestCase
  fixtures :groups, :group_user_map, :users, :accounts, :categories

  def test_create
    g=Group.new :name => "Test Group"
    g.save
    assert_equal(g, Group.find(3))
  end

  def test_list_users
    assert_equal([1, 2], Group.find(1).users.map(&:id).sort)
  end

  def test_list_users2
    assert_equal([1], Group.find(2).users.map(&:id).sort)
  end

  def test_list_accounts
    assert_equal([1, 2], Group.find(1).accounts.map(&:id).sort)
  end

  def test_list_accounts2
    assert_equal([3], Group.find(2).accounts.map(&:id))
  end
end
