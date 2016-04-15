require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = users(:one)
    @other_user = users(:two)
  end

  test "should get index when logged in" do
    sign_in @user
    get :index
    assert_response :success
  end

  test "should redirect index when logged out" do
    get :index
    assert_response :redirect
  end

  test "should get show when logged in" do
    sign_in @user
    get :show, id: @user
    assert_response :success
  end

  test "should redirect show when logged out" do
    get :show, id: @user
    assert_response :redirect
  end

  test "should get edit when logged in" do
    sign_in @user
    get :edit, id: @user
    assert_response :success
  end

  test "should redirect edit when logged out" do
    get :edit, id: @user
    assert_response :redirect
  end

  test "should redirect edit when logged in as the wrong user" do
    sign_in @user
    get :edit, id: @other_user
    assert_response :redirect
  end

  test "should patch update when logged in" do
    sign_in @user
    patch :update, id: @user, profile: { city: nil,
                                         state: nil,
                                         country: nil,
                                         time_zone: nil,
                                         birthday: nil,
                                         gender: nil }
    assert_redirected_to @user
  end

  test "should redirect update when logged out" do
    patch :update, id: @user, profile: { city: nil,
                                         state: nil,
                                         country: nil,
                                         time_zone: nil,
                                         birthday: nil,
                                         gender: nil }
    assert_response :redirect
  end

  test "should redirect update when logged in as the wrong user" do
    sign_in @user
    patch :update, id: @other_user, profile: { city: nil,
                                               state: nil,
                                               country: nil,
                                               time_zone: nil,
                                               birthday: nil,
                                               gender: nil }
    assert_response :redirect
  end
end
