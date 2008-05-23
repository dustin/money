require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :users, :roles

  def test_should_create_user
    assert_difference 'User.count' do
      user = create_user
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_login
    assert_no_difference 'User.count' do
      u = create_user(:login => nil)
      assert u.errors.on(:login)
    end
  end

  def test_should_require_password
    assert_no_difference 'User.count' do
      u = create_user(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference 'User.count' do
      u = create_user(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference 'User.count' do
      u = create_user(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def test_should_reset_password
    users(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal users(:quentin), User.authenticate('quentin', 'new password')
  end

  def test_should_not_rehash_password
    users(:quentin).update_attributes(:login => 'quentin2')
    assert_equal users(:quentin), User.authenticate('quentin2', 'test')
  end

  def test_should_authenticate_user
    assert_equal users(:quentin), User.authenticate('quentin', 'test')
  end

  # My tests...

  def test_quentin_is_admin_from_roles_by_string
    assert users(:quentin).has_role?('admin')
  end

  def test_quentin_is_admin_from_roles_by_object
    assert users(:quentin).has_role?(roles(:admin))
  end

  def test_aaron_is_not_admin_from_roles_by_string
    assert !users(:aaron).has_role?('admin')
  end

  def test_aaron_is_not_admin_from_roles_by_object
    assert !users(:aaron).has_role?(roles(:admin))
  end

  def test_quentin_is_admin?
    assert users(:quentin).admin?
  end

  def test_aaron_is_admin?
    assert !users(:aaron).admin?
  end

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
    assert_equal [1, 2, 3], users(:quentin).roles.map(&:id).sort
  end

protected
  def create_user(options = {})
    User.create({
      :login => 'quire', :email => 'quire@example.com',
      :password => 'quire', :name => 'Quire',
      :password_confirmation => 'quire' }.merge(options))
  end
end
