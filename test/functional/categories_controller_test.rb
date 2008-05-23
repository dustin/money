require File.dirname(__FILE__) + '/../test_helper'

class CategoriesControllerTest < ActionController::TestCase

  # This test just validates the response is successful.
  def test_cat_list
    login_as :quentin
    get :index, {:acct_id => 1}
    assert_response :success
    assert @response.body.include?('Cat1')
    assert @response.body.include?('Cat1')
    assert !@response.body.include?('Cat3')
  end

end
