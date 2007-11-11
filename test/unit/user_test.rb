require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :users, :roles, :groups, :group_user_map,
    :user_roles_map

  def test_should_create_user
    assert_difference User, :count do
      user = create_user
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_login
    assert_no_difference User, :count do
      u = create_user(:login => nil)
      assert u.errors.on(:login)
    end
  end

  def test_should_require_password
    assert_no_difference User, :count do
      u = create_user(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference User, :count do
      u = create_user(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference User, :count do
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

  def test_should_set_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
  end

  def test_should_unset_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    users(:quentin).forget_me
    assert_nil users(:quentin).remember_token
  end
  

  # My tests...
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
    pw='ii28g28g'
    u=User.new :login => 'dustin3', :name => 'Dustin Three',
      :email => 'dustin@spy.net',
      :password => pw, :password_confirmation => pw
    u.save
    assert_equal(3, u.id)
    assert_equal(u, User.find(3))
  end

  def test_lookup_by_name
    u=User.find_by_login('quentin')
    assert_equal(1, u.id)
  end

  protected
    def create_user(options = {})
      User.create({ :login => 'quire', :name => "Sum Guy", :email => 'quire@example.com',
        :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    end
end
