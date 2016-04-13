require 'test_helper'

class FriendRequestsControllerTest < ActionController::TestCase
  def setup
    @user = users(:one)
    @friend_request = friend_requests(:one)
    @wrong_user = users(:last_by_name)
  end

  test "should get index when logged in" do
    sign_in @user
    get :index, user_id: @friend_request.sender
    assert_response :success
  end

  test "should redirect index when logged out" do
    get :index, user_id: @friend_request.sender
    assert_redirected_to new_user_session_path
  end

  test "should redirect index when logged in as the wrong user" do
    sign_in @wrong_user
    get :index, user_id: @friend_request.sender
    assert_redirected_to root_path
  end

  test "should post create when logged in" do
    sign_in @user
    post :create, user_id: @friend_request.sender
    assert_redirected_to users_path
  end

  test "should redirect create when logged out" do
    post :create, user_id: @friend_request.sender
    assert_redirected_to new_user_session_path
  end

  test "should delete destroy when logged in" do
    sign_in @user
    delete :destroy, id: @friend_request
    assert_redirected_to user_friend_requests_path(@friend_request.sender)
  end

  test "should redirect destroy when logged out" do
    delete :destroy, id: @friend_request
    assert_redirected_to new_user_session_path
  end

  test "should redirect destroy when logged in as the wrong user" do
    sign_in @wrong_user
    delete :destroy, id: @friend_request
    assert_redirected_to root_path
  end
end
