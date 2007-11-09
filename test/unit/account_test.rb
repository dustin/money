require File.dirname(__FILE__) + '/../test_helper'

class AccountTest < Test::Unit::TestCase
  fixtures :accounts, :groups

  def test_create
    a=Account.new :name => "Test Account",
      :group => Group.find(1)
    a.save
    assert_equal(a, Account.find(4))
  end

  def test_lookup
    assert_equal(Group.find(1), Account.find(1).group)
  end
end
