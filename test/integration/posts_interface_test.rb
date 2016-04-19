require 'test_helper'

class PostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test "should post from users show page" do
    get new_user_session_path
    assert_template "users/sessions/new"

    post user_session_path, user: { email: @user.email,
                                    password: "password" }
    assert_redirected_to root_path
    follow_redirect!
    assert_template "users/show"

    get user_path(@user)
    assert_template "users/show"

    assert_select "input[type=file]"
    picture = fixture_file_upload("test/fixtures/rails.png", "image/png")
    assert_select "form[action=?]", posts_path
    assert_difference "Post.count", 1 do
      post posts_path, post: { content: "Lorem ipsum.", picture: picture }
    end
    assert assigns(:post).picture?
  end

  test "should post from logged-in home page" do
    get new_user_session_path
    assert_template "users/sessions/new"

    post user_session_path, user: { email: @user.email,
                                    password: "password" }
    assert_redirected_to root_path
    follow_redirect!
    assert_template "users/show"

    assert_select "input[type=file]"
    picture = fixture_file_upload("test/fixtures/rails.png", "image/png")
    assert_select "form[action=?]", posts_path
    assert_difference "Post.count", 1 do
      post posts_path, post: { content: "Lorem ipsum.", picture: picture }
    end
    assert assigns(:post).picture?
  end
end
