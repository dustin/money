require File.dirname(__FILE__) + '/../test_helper'

class MoneyRoleTest < Test::Unit::TestCase
  fixtures :money_users, :money_roles, :money_user_roles_map

  def test_create
    r=MoneyRole.new :name => 'Test Role'
    r.save
    assert_equal(r, MoneyRole.find(3))
  end

  def test_lookup
    MoneyRole.find(:all).each do |r|
      assert_equal(r, MoneyRole.find(r.id))
    end
  end

  def test_user_list
    assert_equal([1, 2], MoneyRole.find(1).users.map(&:id).sort)
  end

  def test_user_list2
    assert_equal([1], MoneyRole.find(2).users.map(&:id))
  end
end
