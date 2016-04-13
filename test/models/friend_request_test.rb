require 'test_helper'

class FriendRequestTest < ActiveSupport::TestCase
  def setup
    @friend_request = friend_requests(:one)

    @user_one = users(:one)
    @user_two = users(:two)
  end

  test "should be valid" do
    assert @friend_request.valid?
  end

  test "sender_id should be present" do
    @friend_request.sender_id = nil
    assert_not @friend_request.valid?
  end

  test "receiver_id should be present" do
    @friend_request.receiver_id = nil
    assert_not @friend_request.valid?
  end

  test "sender_id and receiver_id combinations should be unique" do
    f = FriendRequest.new(sender_id: @user_one.id, receiver_id: @user_two.id)
    assert_not f.valid?
  end

  test "sender_id and receiver_id should not be equal" do
    f = FriendRequest.new(sender_id: @user_one.id, receiver_id: @user_one.id)
    assert_not f.valid?
  end
end
