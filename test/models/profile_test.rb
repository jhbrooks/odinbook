require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  def setup
    @profile = profiles(:one)
  end

  test "should be valid" do
    assert @profile.valid?
  end

  test "time_zone should be a valid time zone name" do
    @profile.time_zone = "invalid"
    assert_not @profile.valid?
  end

  test "time_zone should also be allowed to be blank" do
    @profile.time_zone = ''
    assert @profile.valid?
  end

  test "birthday should be a valid date" do
    @profile.birthday = "invalid"
    assert_not @profile.valid?
  end

  test "birthday should be before or equal to the current date" do
    c_date = Date.today
    @profile.birthday = Date.new(c_date.year, c_date.month, c_date.day + 1)
    assert_not @profile.valid?
  end

  test "birthday should also be allowed to be blank" do
    @profile.birthday = ''
    assert @profile.valid?
  end
end
