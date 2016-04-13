require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test "should display index page with pagination for logged-in users" do
    get users_path
    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_template "users/sessions/new"

    post user_session_path, user: { email: @user.email,
                                    password: "password" }
    assert_redirected_to users_path
    follow_redirect!
    assert_template "users/index"
    assert_select "title", text: full_title("Users")
    User.paginate(page: 1).each do |user|
      unless @user == user
        assert_select "a[href=?]", user_path(user), text: user.name
        if @user.potential_active_friends.include?(user)
          f_r = FriendRequest.where(sender_id: user.id,
                                    receiver_id: @user.id).first
          assert_select "a[href=?]", friend_request_path(f_r),
                                     text: "Ignore friend request"
        elsif @user.potential_passive_friends.include?(user)
          f_r = FriendRequest.where(sender_id: @user.id,
                                    receiver_id: user.id).first
          assert_select "a[href=?]", friend_request_path(f_r),
                                     text: "Cancel friend request"
        else
          assert_select "a[href=?]", user_friend_requests_path(user),
                                     text: "Send friend request"
        end
      end
    end

    get users_path, page: 2
    assert_template "users/index"
    User.paginate(page: 2).each do |user|
      unless @user == user
        assert_select "a[href=?]", user_path(user), text: user.name
        if @user.potential_active_friends.include?(user)
          f_r = FriendRequest.where(sender_id: user.id,
                                    receiver_id: @user.id).first
          assert_select "a[href=?]", friend_request_path(f_r),
                                     text: "Ignore friend request"
        elsif @user.potential_passive_friends.include?(user)
          f_r = FriendRequest.where(sender_id: @user.id,
                                    receiver_id: user.id).first
          assert_select "a[href=?]", friend_request_path(f_r),
                                     text: "Cancel friend request"
        else
          assert_select "a[href=?]", user_friend_requests_path(user),
                                     text: "Send friend request"
        end
      end
    end
  end
end
