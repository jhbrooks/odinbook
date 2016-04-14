require 'test_helper'

class FriendshipsIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test "should display friends with pagination for logged-in users" do
    get user_friendships_path(@user)
    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_template "users/sessions/new"

    post user_session_path, user: { email: @user.email,
                                    password: "password" }
    assert_redirected_to user_friendships_path(@user)
    follow_redirect!
    assert_template "friendships/index"
    assert_select "title", text: full_title("Friends")
    @user.friends.paginate(page: 1).each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
      if @user.friends.include?(user)
        f = Friendship.where(active_friend_id: @user.id,
                             passive_friend_id: user.id).first
        assert_select "a[href=?]", friendship_path(f),
                                   text: "End friendship"
      elsif @user.potential_active_friends.include?(user)
        f_r = FriendRequest.where(sender_id: user.id,
                                  receiver_id: @user.id).first
        assert_select "a[href=?]", user_friendships_path(f_r.sender),
                               text: "Accept friend request"
        assert_select "a[href=?]", friend_request_path(f_r),
                                   text: "Ignore friend request"
      elsif @user.potential_passive_friends.include?(user)
        f_r = FriendRequest.where(sender_id: @user.id,
                                  receiver_id: user.id).first
        assert_select "a[href=?]", friend_request_path(f_r),
                                   text: "Cancel friend request"
      else
        if @user == user
          assert_select "a[href=?]", user_path(@user),
                                     text: "Current user"
        else
          assert_select "a[href=?]", user_friend_requests_path(user),
                                     text: "Send friend request"
        end
      end
    end

    get user_friendships_path(@user), page: 2
    assert_template "friendships/index"
    @user.friends.paginate(page: 2).each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
      if @user.friends.include?(user)
        f = Friendship.where(active_friend_id: @user.id,
                             passive_friend_id: user.id).first
        assert_select "a[href=?]", friendship_path(f),
                                   text: "End friendship"
      elsif @user.potential_active_friends.include?(user)
        f_r = FriendRequest.where(sender_id: user.id,
                                  receiver_id: @user.id).first
        assert_select "a[href=?]", user_friendships_path(f_r.sender),
                               text: "Accept friend request"
        assert_select "a[href=?]", friend_request_path(f_r),
                                   text: "Ignore friend request"
      elsif @user.potential_passive_friends.include?(user)
        f_r = FriendRequest.where(sender_id: @user.id,
                                  receiver_id: user.id).first
        assert_select "a[href=?]", friend_request_path(f_r),
                                   text: "Cancel friend request"
      else
        if @user == user
          assert_select "a[href=?]", user_path(@user),
                                     text: "Current user"
        else
          assert_select "a[href=?]", user_friend_requests_path(user),
                                     text: "Send friend request"
        end
      end
    end
  end
end
