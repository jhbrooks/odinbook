require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
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
    assert_template "static_pages/home"

    get user_path(user)
    assert_template "users/show"
    assert_select "title", text: full_title(user.name)
  end
end
