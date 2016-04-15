require 'test_helper'

class StaticPagesHomeTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @profile = profiles(:one)
  end

  test "should display home page for logged-out users" do
    get root_path
    assert_template "static_pages/home"
    assert_select "h1", text: "Welcome to Odinbook"
  end

  test "should display home page for logged-in users" do
    get new_user_session_path
    assert_template "users/sessions/new"

    post user_session_path, user: { email: @user.email,
                                    password: "password" }
    assert_redirected_to root_path
    follow_redirect!
    assert_template "users/show"
    assert_select "title", text: full_title
    assert_match @user.name, response.body
    assert_match CGI.escapeHTML(@profile.city), response.body
    assert_match @profile.state, response.body
    assert_match @profile.country, response.body
    assert_match CGI.escapeHTML(@profile.time_zone), response.body
    assert_match formatted_birthday(@profile.birthday), response.body
    assert_match @profile.age.to_s, response.body
    assert_match @profile.gender, response.body

    assert_select "h3", text: "Timeline"
    assert_select "div#post_form", count: 1

    @user.posts.paginate(page: 1).each do |post|
      assert_select "span", text: post.content
      assert_select "a[href=?]", user_path(post.user), text: post.user.name
      if post.user.profile.time_zone
        assert_select "span", text: formatted_datetime(post.created_at
          .in_time_zone(post.user.profile.time_zone))
      else
        assert_select "span", text: formatted_datetime(post.created_at)
      end
    end

    get user_path(@user), page: 2
    assert_template "users/show"
    @user.posts.paginate(page: 2).each do |post|
      assert_select "span", text: post.content
      assert_select "a[href=?]", user_path(post.user), text: post.user.name
      if post.user.profile.time_zone
        assert_select "span", text: formatted_datetime(post.created_at
          .in_time_zone(post.user.profile.time_zone))
      else
        assert_select "span", text: formatted_datetime(post.created_at)
      end
    end
  end
end
