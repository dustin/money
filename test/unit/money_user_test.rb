require File.dirname(__FILE__) + '/../test_helper'

class MoneyUserTest < Test::Unit::TestCase
  fixtures :money_users, :money_roles, :money_groups, :money_group_user_map,
    :money_user_roles_map

  def test_user_list_length
    assert_equal(2, MoneyUser.find(:all).length) 
  end

  def test_user_group_relation
    assert_equal([MoneyGroup.find(1)], MoneyUser.find(2).groups)
  end

  def test_user_group_relation2
    assert_equal([1, 2], MoneyUser.find(1).groups.map(&:id).sort)
  end

  def test_user_role_map
    assert_equal([MoneyRole.find(1)], MoneyUser.find(2).roles)
  end

  def test_user_role_map2
    assert_equal([1, 2], MoneyUser.find(1).roles.map(&:id).sort)
  end

  def test_creation
    u=MoneyUser.new :username => 'dustin3', :name => 'Dustin Three',
      :hash => 'ii28g28g'
    u.save
    assert_equal(3, u.id)
    assert_equal(u, MoneyUser.find(3))
  end
end
