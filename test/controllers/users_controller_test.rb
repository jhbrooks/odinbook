require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = users(:one)
  end

  test "should get index when logged in" do
    sign_in @user
    get :index
    assert_response :success
  end

  test "should redirect index when logged out" do
    get :index
    assert_response :redirect
  end
end
