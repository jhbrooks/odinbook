require 'test_helper'

class FriendRequestsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user_one = users(:one)
    @user_two = users(:two)
    @other_user = users(:last_by_name)
    @friend_request_two = friend_requests(:two)
    @friend_request_three = friend_requests(:three)
  end

  test "should send request from users index page" do
    get new_user_session_path
    assert_template "users/sessions/new"
    post user_session_path, user: { email: @user_two.email,
                                    password: "password" }
    assert_redirected_to root_path
    follow_redirect!
    assert_template "static_pages/home"

    get users_path, page: 2
    assert_template "users/index"
    assert_select "a[href=?]", user_friend_requests_path(@other_user),
                               text: "Send friend request"
    assert_difference "FriendRequest.count", 1 do
      post user_friend_requests_path(@other_user)
    end
  end

  test "should handle hitting send twice" do
    get new_user_session_path
    assert_template "users/sessions/new"
    post user_session_path, user: { email: @user_two.email,
                                    password: "password" }
    assert_redirected_to root_path
    follow_redirect!
    assert_template "static_pages/home"

    get users_path, page: 2
    assert_template "users/index"
    assert_select "a[href=?]", user_friend_requests_path(@other_user),
                               text: "Send friend request"
    assert_difference "FriendRequest.count", 1 do
      post user_friend_requests_path(@other_user)
    end
    assert_difference "FriendRequest.count", 0 do
      post user_friend_requests_path(@other_user)
    end
    assert_not flash.empty?
    assert_redirected_to users_path
  end

  test "should ignore request from users index page" do
    get new_user_session_path
    assert_template "users/sessions/new"
    post user_session_path, user: { email: @user_one.email,
                                    password: "password" }
    assert_redirected_to root_path
    follow_redirect!
    assert_template "static_pages/home"

    get users_path, page: 2
    assert_template "users/index"
    assert_select "a[href=?]", friend_request_path(@friend_request_two),
                               text: "Ignore friend request"
    assert_difference "FriendRequest.count", -1 do
      delete friend_request_path(@friend_request_two)
    end
  end

  test "should cancel request from users index page" do
    get new_user_session_path
    assert_template "users/sessions/new"
    post user_session_path, user: { email: @user_one.email,
                                    password: "password" }
    assert_redirected_to root_path
    follow_redirect!
    assert_template "static_pages/home"

    get users_path, page: 2
    assert_template "users/index"
    assert_select "a[href=?]", friend_request_path(@friend_request_three),
                               text: "Cancel friend request"
    assert_difference "FriendRequest.count", -1 do
      delete friend_request_path(@friend_request_three)
    end
  end

  test "should ignore request from friend requests index page" do
    get new_user_session_path
    assert_template "users/sessions/new"
    post user_session_path, user: { email: @user_one.email,
                                    password: "password" }
    assert_redirected_to root_path
    follow_redirect!
    assert_template "static_pages/home"

    get user_friend_requests_path(@user_one)
    assert_template "friend_requests/index"
    assert_select "a[href=?]", friend_request_path(@friend_request_two),
                               text: "Ignore friend request"
    assert_difference "FriendRequest.count", -1 do
      delete friend_request_path(@friend_request_two)
    end
  end

  test "should cancel request from friend requests index page" do
    get new_user_session_path
    assert_template "users/sessions/new"
    post user_session_path, user: { email: @user_one.email,
                                    password: "password" }
    assert_redirected_to root_path
    follow_redirect!
    assert_template "static_pages/home"

    get user_friend_requests_path(@user_one)
    assert_template "friend_requests/index"
    assert_select "a[href=?]", friend_request_path(@friend_request_three),
                               text: "Cancel friend request"
    assert_difference "FriendRequest.count", -1 do
      delete friend_request_path(@friend_request_three)
    end
  end

  test "should handle hitting ignore or cancel twice" do
    get new_user_session_path
    assert_template "users/sessions/new"
    post user_session_path, user: { email: @user_one.email,
                                    password: "password" }
    assert_redirected_to root_path
    follow_redirect!
    assert_template "static_pages/home"

    get user_friend_requests_path(@user_one)
    assert_template "friend_requests/index"
    assert_select "a[href=?]", friend_request_path(@friend_request_three),
                               text: "Cancel friend request"
    assert_difference "FriendRequest.count", -1 do
      delete friend_request_path(@friend_request_three)
    end
    assert_difference "FriendRequest.count", 0 do
      delete friend_request_path(@friend_request_three)
    end
    assert_not flash.empty?
    assert_redirected_to user_friend_requests_path(@user_one)
  end
end
