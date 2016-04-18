require 'test_helper'

class ReactionsControllerTest < ActionController::TestCase
  def setup
    @user = users(:one)
    @post = posts(:one)
  end

  test "should post create when logged in" do
    sign_in @user
    post :create, post_id: @post.id
    assert_redirected_to root_path
  end

  test "should redirect create when logged out" do
    post :create, post_id: @post.id
    assert_redirected_to new_user_session_path
  end
end
