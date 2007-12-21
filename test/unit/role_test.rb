require File.dirname(__FILE__) + '/../test_helper'

class RoleTest < Test::Unit::TestCase
  fixtures :users, :roles, :user_roles_map

  def test_create
    r=Role.new :name => 'Test Role'
    r.save
    assert_equal(r, Role.find(r.id))
  end

  def test_lookup
    Role.find(:all).each do |r|
      assert_equal(r, Role.find(r.id))
    end
  end

  def test_user_list
    assert_equal([1, 2], Role.find(1).users.map(&:id).sort)
  end

  def test_user_list2
    assert_equal([1], Role.find(2).users.map(&:id))
  end
end
