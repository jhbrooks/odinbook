require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @last_by_name = users(:last_by_name)
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = " "
    assert_not @user.valid?
  end

  test "should be sorted by name in ascending order" do
    assert_equal @last_by_name, User.last
  end
end
