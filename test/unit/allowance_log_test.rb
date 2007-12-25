require File.dirname(__FILE__) + '/../test_helper'

class AllowanceLogTest < Test::Unit::TestCase
  fixtures :allowance_logs, :allowance_tasks, :users

  def test_latest
    l=AllowanceLog.find_latest allowance_tasks(:one)
    assert_equal 2, l.id
  end

end
