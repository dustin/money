require File.dirname(__FILE__) + '/../test_helper'

class MoneyCategoryTest < Test::Unit::TestCase
  fixtures :money_categories, :money_groups

  def test_create
    c=MoneyCategory.new :name => 'Test Cat', :budget => 37.25,
      :group => MoneyGroup.find(1)
    c.save
    assert_equal(MoneyGroup.find(1), MoneyCategory.find(4).group)
  end

  def test_create2
    g=MoneyGroup.find(1)
    c=g.categories.create(:name => 'Test Cat', :budget => 37.25)
    c.save
    assert_equal(g, MoneyCategory.find(4).group)
  end

  def test_lookup
    c=MoneyCategory.find(1)
    assert_equal('Cat1', c.name)
    assert_in_delta(300.50, c.budget.to_f, 2 ** -20)
    assert_equal(MoneyGroup.find(1), c.group)
  end

  def test_lookup2
    c=MoneyCategory.find(2)
    assert_equal('Cat2', c.name)
    assert_nil(c.budget)
    assert_equal(MoneyGroup.find(1), c.group)
  end

  def test_find_by_group
    assert_equal([1, 2], MoneyGroup.find(1).categories.map(&:id).sort)
  end
end
