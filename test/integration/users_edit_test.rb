require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @profile = profiles(:one)
  end

  test "should handle invalid edits for correct logged-in users" do
    get edit_user_path(@user)
    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_template "users/sessions/new"

    post user_session_path, user: { email: @user.email,
                                    password: "password" }
    assert_redirected_to edit_user_path(@user)
    follow_redirect!
    assert_template "users/edit"
    assert_select "title", text: full_title("Edit profile")

    patch user_path(@user), profile: { city: nil,
                                       state: nil,
                                       country: nil,
                                       time_zone: "invalid",
                                       birthday: "invalid",
                                       gender: nil }
    assert_template "users/edit"
    assert_template "shared/_error_messages"
    assert_select "div#error_explanation"
    assert_select "div.field_with_errors"
  end

  test "should handle valid edits for correct logged-in users" do
    get new_user_session_path
    assert_template "users/sessions/new"
    post user_session_path, user: { email: @user.email,
                                    password: "password" }
    assert_redirected_to root_path
    follow_redirect!
    assert_template "static_pages/home"

    get edit_user_path(@user)
    assert_template "users/edit"
    assert_select "title", text: full_title("Edit profile")

    city = "Chicago"
    state = "IL"
    country = "USA"
    time_zone = "Central Time (US & Canada)"
    birthday = "2000-04-11"
    gender = "Other"
    patch user_path(@user), profile: { city: city,
                                       state: state,
                                       country: country,
                                       time_zone: time_zone,
                                       birthday: birthday,
                                       gender: gender }
    assert_not flash.empty?
    assert_redirected_to @user
    @profile.reload
    assert_equal city, @profile.city
    assert_equal state, @profile.state
    assert_equal country, @profile.country
    assert_equal time_zone, @profile.time_zone
    assert_equal birthday, @profile.birthday.to_s
    assert_equal gender, @profile.gender
  end
end
