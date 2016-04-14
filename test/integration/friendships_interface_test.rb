require 'test_helper'

class FriendshipsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user_one = users(:one)
    @user_two = users(:two)
    @user_three = users(:three)

    @friendship_one = friendships(:one)
  end

  test "should accept friend request from users index page" do
    get new_user_session_path
    assert_template "users/sessions/new"
    post user_session_path, user: { email: @user_two.email,
                                    password: "password" }
    assert_redirected_to root_path
    follow_redirect!
    assert_template "static_pages/home"

    get users_path, page: 2
    assert_template "users/index"
    assert_select "a[href=?]", user_friendships_path(@user_one),
                               text: "Accept friend request"
    assert_difference "FriendRequest.count", -2 do
      assert_difference "Friendship.count", 2 do
        post user_friendships_path(@user_one)
      end
    end
  end

  test "should end friendship from users index page" do
    get new_user_session_path
    assert_template "users/sessions/new"
    post user_session_path, user: { email: @user_one.email,
                                    password: "password" }
    assert_redirected_to root_path
    follow_redirect!
    assert_template "static_pages/home"

    get users_path, page: 2
    assert_template "users/index"
    assert_select "a[href=?]", friendship_path(@friendship_one),
                               text: "End friendship"
    assert_difference "Friendship.count", -2 do
      delete friendship_path(@friendship_one)
    end
  end

  test "should accept friend request from friend requests index page" do
    get new_user_session_path
    assert_template "users/sessions/new"
    post user_session_path, user: { email: @user_two.email,
                                    password: "password" }
    assert_redirected_to root_path
    follow_redirect!
    assert_template "static_pages/home"

    get user_friend_requests_path(@user_two)
    assert_template "friend_requests/index"
    assert_select "a[href=?]", user_friendships_path(@user_one),
                               text: "Accept friend request"
    assert_difference "FriendRequest.count", -2 do
      assert_difference "Friendship.count", 2 do
        post user_friendships_path(@user_one)
      end
    end
  end

  test "should accept friend request from friendships index page" do
    get new_user_session_path
    assert_template "users/sessions/new"
    post user_session_path, user: { email: @user_two.email,
                                    password: "password" }
    assert_redirected_to root_path
    follow_redirect!
    assert_template "static_pages/home"

    get user_friendships_path(@user_three), page: 1
    assert_template "friendships/index"
    assert_select "a[href=?]", user_friendships_path(@user_one),
                               text: "Accept friend request"
    assert_difference "FriendRequest.count", -2 do
      assert_difference "Friendship.count", 2 do
        post user_friendships_path(@user_one)
      end
    end
  end

  test "should end friendship from friendships index page" do
    get new_user_session_path
    assert_template "users/sessions/new"
    post user_session_path, user: { email: @user_one.email,
                                    password: "password" }
    assert_redirected_to root_path
    follow_redirect!
    assert_template "static_pages/home"

    get user_friendships_path(@user_two), page: 1
    assert_template "friendships/index"
    assert_select "a[href=?]", friendship_path(@friendship_one),
                               text: "End friendship"
    assert_difference "Friendship.count", -2 do
      delete friendship_path(@friendship_one)
    end
  end

  test "should handle hitting accept twice" do
    get new_user_session_path
    assert_template "users/sessions/new"
    post user_session_path, user: { email: @user_two.email,
                                    password: "password" }
    assert_redirected_to root_path
    follow_redirect!
    assert_template "static_pages/home"

    get users_path, page: 2
    assert_template "users/index"
    assert_select "a[href=?]", user_friendships_path(@user_one),
                               text: "Accept friend request"
    assert_difference "FriendRequest.count", -2 do
      assert_difference "Friendship.count", 2 do
        post user_friendships_path(@user_one)
      end
    end
    assert_difference "FriendRequest.count", 0 do
      assert_difference "Friendship.count", 0 do
        post user_friendships_path(@user_one)
      end
    end
    assert_not flash.empty?
    assert_redirected_to user_friend_requests_path(@user_two)
  end

  test "should handle hitting end twice" do
    get new_user_session_path
    assert_template "users/sessions/new"
    post user_session_path, user: { email: @user_one.email,
                                    password: "password" }
    assert_redirected_to root_path
    follow_redirect!
    assert_template "static_pages/home"

    get users_path, page: 2
    assert_template "users/index"
    assert_select "a[href=?]", friendship_path(@friendship_one),
                               text: "End friendship"
    assert_difference "Friendship.count", -2 do
      delete friendship_path(@friendship_one)
    end
    assert_difference "Friendship.count", 0 do
      delete friendship_path(@friendship_one)
    end
    assert_not flash.empty?
    assert_redirected_to user_friendships_path(@user_one)
  end
end
