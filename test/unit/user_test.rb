require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users, :roles, :groups, :group_user_map,
    :user_roles_map

  def test_user_list_length
    assert_equal(2, User.find(:all).length) 
  end

  def test_user_group_relation
    assert_equal([Group.find(1)], User.find(2).groups)
  end

  def test_user_group_relation2
    assert_equal([1, 2], User.find(1).groups.map(&:id).sort)
  end

  def test_user_role_map
    assert_equal([Role.find(1)], User.find(2).roles)
  end

  def test_user_role_map2
    assert_equal([1, 2], User.find(1).roles.map(&:id).sort)
  end

  def test_creation
    u=User.new :username => 'dustin3', :name => 'Dustin Three',
      :hash => 'ii28g28g'
    u.save
    assert_equal(3, u.id)
    assert_equal(u, User.find(3))
  end

  def test_lookup_by_name
    u=User.find_by_username('dustin')
    assert_equal(1, u.id)
  end

end
