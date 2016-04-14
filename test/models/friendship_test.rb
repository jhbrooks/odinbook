require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase
  def setup
    @friendship = friendships(:one)

    @user_one = users(:one)
    @other_user = users(:three)
  end

  test "should be valid" do
    assert @friendship.valid?
  end

  test "active_friend_id should be present" do
    @friendship.active_friend_id = nil
    assert_not @friendship.valid?
  end

  test "passive_friend_id should be present" do
    @friendship.passive_friend_id = nil
    assert_not @friendship.valid?
  end

  test "active_friend_id and passive_friend_id pairs should be unique" do
    f = Friendship.new(active_friend_id: @user_one.id,
                       passive_friend_id: @other_user.id)
    assert_not f.valid?
  end

  test "active_friend_id and passive_friend_id should not be equal" do
    f = Friendship.new(active_friend_id: @user_one.id,
                       passive_friend_id: @user_one.id)
    assert_not f.valid?
  end
end
