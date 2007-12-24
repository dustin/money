require File.dirname(__FILE__) + '/../test_helper'
require 'report_controller'

# Re-raise errors caught by the controller.
class ReportController; def rescue_action(e) raise e end; end

class ReportControllerTest < Test::Unit::TestCase

  include AuthenticatedTestHelper

  fixtures :users

  def setup
    @controller = ReportController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    login_as :dustin
    get :index
    assert_response :success
  end

  def test_balances
    login_as :dustin
    get :balances
    assert_response :success
  end

  def test_flow_month
    login_as :dustin
    get :month_flow, :id => 1
    assert_response :success
    assert assigns['flow']
  end
  def test_flow_year
    login_as :dustin
    get :year_flow, :id => 1
    assert_response :success
    assert assigns['flow']
  end

  def test_unauthorized_index
    login_as :aaron
    get :index
    assert_response :success
    assert_template "report/access_denied"
  end

end
