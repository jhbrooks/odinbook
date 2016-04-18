require 'test_helper'

class ReactionsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @post = posts(:one)
    @comment = comments(:one)
  end

  test "should like posts from users show page" do
    get new_user_session_path
    assert_template "users/sessions/new"

    post user_session_path, user: { email: @user.email,
                                    password: "password" }
    assert_redirected_to root_path
    follow_redirect!
    assert_template "users/show"

    get user_path(@user)
    assert_template "users/show"

    assert_select "a[href=?]", post_reactions_path(@post), text: "Like"
    assert_difference "Reaction.count", 1 do
      post post_reactions_path(@post)
    end
  end

  test "should like posts from logged-in home page" do
    get new_user_session_path
    assert_template "users/sessions/new"

    post user_session_path, user: { email: @user.email,
                                    password: "password" }
    assert_redirected_to root_path
    follow_redirect!
    assert_template "users/show"

    assert_select "a[href=?]", post_reactions_path(@post), text: "Like"
    assert_difference "Reaction.count", 1 do
      post post_reactions_path(@post)
    end
  end

  test "should handle hitting like twice" do
    get new_user_session_path
    assert_template "users/sessions/new"
    post user_session_path, user: { email: @user.email,
                                    password: "password" }
    assert_redirected_to root_path
    follow_redirect!
    assert_template "users/show"

    assert_select "a[href=?]", post_reactions_path(@post), text: "Like"
    assert_difference "Reaction.count", 1 do
      post post_reactions_path(@post)
    end
    assert_redirected_to root_path
    follow_redirect!
    assert_template "users/show"

    assert_select "a[href=?]", post_reactions_path(@post), text: "Like",
                                                           count: 0
    assert_difference "Reaction.count", 0 do
      post post_reactions_path(@post)
    end
    assert_not flash.empty?
    assert_redirected_to root_path
  end

  test "should like comments from users show page" do
    get new_user_session_path
    assert_template "users/sessions/new"

    post user_session_path, user: { email: @user.email,
                                    password: "password" }
    assert_redirected_to root_path
    follow_redirect!
    assert_template "users/show"

    get user_path(@user)
    assert_template "users/show"

    assert_select "a[href=?]", comment_reactions_path(@comment), text: "Like"
    assert_difference "Reaction.count", 1 do
      post comment_reactions_path(@comment)
    end
  end

  test "should like comments from logged-in home page" do
    get new_user_session_path
    assert_template "users/sessions/new"

    post user_session_path, user: { email: @user.email,
                                    password: "password" }
    assert_redirected_to root_path
    follow_redirect!
    assert_template "users/show"

    assert_select "a[href=?]", comment_reactions_path(@comment), text: "Like"
    assert_difference "Reaction.count", 1 do
      post comment_reactions_path(@comment)
    end
  end
end
