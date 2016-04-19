require 'test_helper'

class UsersRegistrationsDestroyTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)

    post user_session_path, user: { email: @user.email,
                                    password: "password" }
  end

  test "should destroy a user" do
    assert_difference "User.count", -1 do
      delete user_registration_path
    end
  end

  test "should destroy the associated profile" do
    assert_difference "Profile.count", -1 do
      delete user_registration_path
    end
  end

  test "should destroy associated friend requests" do
    d = @user.sent_friend_requests.count + @user.received_friend_requests.count
    assert_difference "FriendRequest.count", -d do
      delete user_registration_path
    end
  end

  test "should destroy associated friendships" do
    d = @user.friendships.count + @user.passive_friendships.count
    assert_difference "Friendship.count", -d do
      delete user_registration_path
    end
  end

  test "should destroy associated posts and their comments and reactions" do
    d = @user.posts.count
    c_d = @user.comments.count
    r_d = @user.reactions.count
    @user.posts.each do |post|
      c_d += post.comments.count
      c_d -= post.comments.where(user_id: @user.id).count
      r_d += post.reactions.count
      r_d -= post.reactions.where(user_id: @user.id).count
      post.comments.each do |comment|
        r_d += comment.reactions.count
        r_d -= comment.reactions.where(user_id: @user.id).count
      end
    end

    assert_difference "Post.count", -d do
      assert_difference "Comment.count", -c_d do
        assert_difference "Reaction.count", -r_d do
          delete user_registration_path
        end
      end
    end
  end

  test "should destroy associated comments and their reactions" do
    c_d = @user.comments.count
    r_d = @user.reactions.count
    @user.posts.each do |post|
      c_d += post.comments.count
      c_d -= post.comments.where(user_id: @user.id).count
      r_d += post.reactions.count
      r_d -= post.reactions.where(user_id: @user.id).count
      post.comments.each do |comment|
        r_d += comment.reactions.count
        r_d -= comment.reactions.where(user_id: @user.id).count
      end
    end

    assert_difference "Comment.count", -c_d do
      assert_difference "Reaction.count", -r_d do
        delete user_registration_path
      end
    end
  end

  test "should destroy associated reactions" do
    r_d = @user.reactions.count
    @user.posts.each do |post|
      r_d += post.reactions.count
      r_d -= post.reactions.where(user_id: @user.id).count
      post.comments.each do |comment|
        r_d += comment.reactions.count
        r_d -= comment.reactions.where(user_id: @user.id).count
      end
    end

    assert_difference "Reaction.count", -r_d do
      delete user_registration_path
    end
  end
end
