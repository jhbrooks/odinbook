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
    User.paginate(page: 1).each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
      assert_select "a[href=?]", "#", text: "Send friend request"
    end

    get users_path, page: 2
    assert_template "users/index"
    User.paginate(page: 2).each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
      assert_select "a[href=?]", "#", text: "Send friend request"
    end
  end
end
