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
    get :month_flow
    assert_response :success
    assert assigns['flow']
  end

  def test_flow_year
    login_as :dustin
    get :year_flow
    assert_response :success
    assert assigns['flow']
  end

  def test_month_cat_form
    login_as :dustin
    get :month_cat_form
    assert_equal Date.today, assigns['today']
  end

  def test_month_cat
    login_as :dustin
    get :month_cat, :year => 2007, :month => 11
    assert_response :success
    assert assigns['cats']
    assert assigns['year'] == 2007
    assert assigns['month'] == 11
  end

  def test_month_cat_by_date
    login_as :dustin
    get :month_cat, :date => '2007-11-01'
    assert_response :success
    assert assigns['cats']
    assert assigns['year'] == 2007
    assert assigns['month'] == 11
  end

  def test_month_cat_txns
    login_as :dustin
    get :month_cat_txns, :date => '2007-11-01', :cat => 1
    assert_response :success
    assert assigns['txns']
    assert assigns['year'] == 2007
    assert assigns['month'] == 11
  end

  def test_unauthorized_index
    login_as :aaron
    get :index
    assert_response :success
    assert_template "report/access_denied"
  end

end
