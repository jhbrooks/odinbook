require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @user_two = users(:two)
    @profile = profiles(:one)
  end

  test "should display show page for logged-in users" do
    get user_path(@user)
    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_template "users/sessions/new"

    post user_session_path, user: { email: @user.email,
                                    password: "password" }
    assert_redirected_to user_path(@user)
    follow_redirect!
    assert_template "users/show"
    assert_select "title", text: full_title(@user.name)
    assert_match @user.name, response.body
    assert_match CGI.escapeHTML(@profile.city), response.body
    assert_match @profile.state, response.body
    assert_match @profile.country, response.body
    assert_match CGI.escapeHTML(@profile.time_zone), response.body
    assert_match formatted_birthday(@profile.birthday), response.body
    assert_match @profile.age.to_s, response.body
    assert_match @profile.gender, response.body

    assert_select "h1", text: "Profile"
    assert_select "h3", text: "Posts"
    assert_select "div#post_form", count: 1
    assert_select "input[type=file]", count: 1

    @user.posts.paginate(page: 1).each do |post|
      assert_select "span", text: post.content
      assert_select "a[href=?]", user_path(post.user), text: post.user.name
      if @user.profile.time_zone
        assert_select "span", text: formatted_datetime(post.created_at
          .in_time_zone(@user.profile.time_zone))
      else
        assert_select "span", text: formatted_datetime(post.created_at)
      end

      if post.reactions.exists?
        assert_match post.reactions.count.to_s, response.body
      end
      unless post.reactions.where(user_id: @user.id).exists?
        assert_select "a[href=?]", post_reactions_path(post), text: "Like"
      end

      post.comments.each do |comment|
        assert_select "span", text: comment.content
        assert_select "a[href=?]", user_path(comment.user),
                                   text: comment.user.name
        if @user.profile.time_zone
          assert_select "span", text: formatted_datetime(comment.created_at
            .in_time_zone(@user.profile.time_zone))
        else
          assert_select "span", text: formatted_datetime(comment.created_at)
        end

        if comment.reactions.exists?
          assert_match comment.reactions.count.to_s, response.body
        end
        unless comment.reactions.where(user_id: @user.id).exists?
          assert_select "a[href=?]", comment_reactions_path(comment),
                                     text: "Like"
        end
      end
      assert_select "form[action=?]", post_comments_path(post), count: 1
    end

    get user_path(@user), page: 2
    assert_template "users/show"
    @user.posts.paginate(page: 2).each do |post|
      assert_select "span", text: post.content
      assert_select "a[href=?]", user_path(post.user), text: post.user.name
      if @user.profile.time_zone
        assert_select "span", text: formatted_datetime(post.created_at
          .in_time_zone(@user.profile.time_zone))
      else
        assert_select "span", text: formatted_datetime(post.created_at)
      end

      if post.reactions.exists?
        assert_match post.reactions.count.to_s, response.body
      end
      unless post.reactions.where(user_id: @user.id).exists?
        assert_select "a[href=?]", post_reactions_path(post), text: "Like"
      end

      post.comments.each do |comment|
        assert_select "span", text: comment.content
        assert_select "a[href=?]", user_path(comment.user),
                                   text: comment.user.name
        if @user.profile.time_zone
          assert_select "span", text: formatted_datetime(comment.created_at
            .in_time_zone(@user.profile.time_zone))
        else
          assert_select "span", text: formatted_datetime(comment.created_at)
        end

        if comment.reactions.exists?
          assert_match comment.reactions.count.to_s, response.body
        end
        unless comment.reactions.where(user_id: @user.id).exists?
          assert_select "a[href=?]", comment_reactions_path(comment),
                                     text: "Like"
        end
      end
      assert_select "form[action=?]", post_comments_path(post), count: 1
    end
  end

  test "should display show page for new users" do
    get new_user_registration_path
    assert_template "users/registrations/new"
    post user_registration_path, user: { name: "new",
                                         email: "new@example.com",
                                         password: "password",
                                         password_confirmation: "password" }
    user = User.find_by(email: "new@example.com")
    profile = user.profile
    assert_redirected_to root_path
    follow_redirect!
    assert_template "users/show"

    get user_path(user)
    assert_template "users/show"
    assert_select "title", text: full_title(user.name)
  end

  test "should display show page without post form for other users" do
    get new_user_session_path
    assert_template "users/sessions/new"

    post user_session_path, user: { email: @user.email,
                                    password: "password" }
    assert_redirected_to root_path
    follow_redirect!
    assert_template "users/show"

    get user_path(@user_two)
    assert_template "users/show"
    assert_select "div#post_form", count: 0
    assert_select "input[type=file]", count: 0
  end
end
