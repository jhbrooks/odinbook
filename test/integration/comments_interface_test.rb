require 'test_helper'

class CommentsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @post = posts(:one)
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

    assert_select "form[action=?]", post_comments_path(@post)
    assert_difference "Comment.count", 1 do
      post post_comments_path(@post), comment: { content: "Lorem ipsum." }
    end
  end

  test "should post from logged-in home page" do
    get new_user_session_path
    assert_template "users/sessions/new"

    post user_session_path, user: { email: @user.email,
                                    password: "password" }
    assert_redirected_to root_path
    follow_redirect!
    assert_template "users/show"

    assert_select "form[action=?]", post_comments_path(@post)
    assert_difference "Comment.count", 1 do
      post post_comments_path(@post), comment: { content: "Lorem ipsum." }
    end
  end
end
