require File.dirname(__FILE__) + '/../test_helper'

class AllowanceLogTest < Test::Unit::TestCase
  fixtures :allowance_logs, :allowance_tasks, :users

  def test_latest
    l=AllowanceLog.find_latest AllowanceTask.find(1)
    assert_equal(2, l.id)
  end

  def test_all_latest
    u=User.find 2
    assert_equal([2, 3], AllowanceLog.find_all_latest(u).map(&:id).sort)
  end

  def test_all_latest_none
    u=User.find 1
    assert_equal([], AllowanceLog.find_all_latest(u))
  end
end
