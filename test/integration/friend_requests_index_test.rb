require 'test_helper'

class FriendRequestsIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test "should display received and sent requests for logged-in users" do
    get user_friend_requests_path(@user)
    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_template "users/sessions/new"

    post user_session_path, user: { email: @user.email,
                                    password: "password" }
    assert_redirected_to user_friend_requests_path(@user)
    follow_redirect!
    assert_template "friend_requests/index"
    assert_select "title", text: full_title("Friend requests")

    @user.received_friend_requests.each do |request|
      assert_select "a[href=?]", user_path(request.sender),
                                 text: request.sender.name
      assert_select "a[href=?]", friend_request_path(request),
                                 text: "Ignore friend request"
    end

    @user.sent_friend_requests.each do |request|
      assert_select "a[href=?]", user_path(request.receiver),
                                 text: request.receiver.name
      assert_select "a[href=?]", friend_request_path(request),
                                 text: "Cancel friend request"
    end
  end
end
