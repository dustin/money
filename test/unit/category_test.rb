require File.dirname(__FILE__) + '/../test_helper'

class CategoryTest < Test::Unit::TestCase
  fixtures :categories, :groups

  def test_create
    c=Category.new :name => 'Test Cat', :budget => 37.25,
      :group => Group.find(1)
    c.save
    assert_equal Group.find(1), Category.find(c.id).group
  end

  def test_create2
    g=Group.find(1)
    c=g.categories.create :name => 'Test Cat', :budget => 37.25
    c.save
    assert_equal g, Category.find(c.id).group
  end

  def test_lookup
    c=Category.find(1)
    assert_equal 'Cat1', c.name
    assert_in_delta 300.50, c.budget.to_f, 2 ** -20
    assert_equal Group.find(1), c.group
  end

  def test_lookup2
    c=Category.find 2
    assert_equal 'Cat2', c.name
    assert_nil c.budget
    assert_equal Group.find(1), c.group
  end

  def test_find_by_group
    assert_equal [1, 2], Group.find(1).categories.map(&:id).sort
  end

  def test_order
    assert_equal [1, 3, 2], Category.find(:all, :order => "name desc").sort.map(&:id)
  end
end
