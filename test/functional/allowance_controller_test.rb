require File.dirname(__FILE__) + '/../test_helper'
require 'allowance_controller'

# Re-raise errors caught by the controller.
class AllowanceController; def rescue_action(e) raise e end; end

class AllowanceControllerTest < Test::Unit::TestCase

  include AuthenticatedTestHelper

  fixtures :users, :allowance_tasks, :allowance_logs, :groups, :categories
  fixtures :money_transactions

  def setup
    @controller = AllowanceController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_complete
    login_as :aaron
    assert_difference MoneyTransaction, :count, 4 do
      post :complete, :task => {"1" => "on", "3" => "on"}
    end
  end

  def test_redoing_unavailable
    login_as :aaron
    assert_difference MoneyTransaction, :count, 0 do
      post :complete, :task => {"2" => "on"}
    end
  end

end
