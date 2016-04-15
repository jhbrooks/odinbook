require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  def setup
    @user = users(:one)
  end

  test "should post create when logged in" do
    sign_in @user
    post :create, post: { content: "Lorem ipsum.", user_id: @user.id }
    assert_redirected_to root_path
  end

  test "should redirect create when logged out" do
    post :create, post: { content: "Lorem ipsum.", user_id: @user.id }
    assert_redirected_to new_user_session_path
  end
end
