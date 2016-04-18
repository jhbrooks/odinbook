require 'test_helper'

class ReactionTest < ActiveSupport::TestCase
  def setup
    @reaction = reactions(:one)
    @user = users(:two)
    @post = posts(:one)
  end

  test "should be valid" do
    assert @reaction.valid?
  end

  test "mode should be present" do
    @reaction.mode = " "
    assert_not @reaction.valid?
  end

  test "mode should be a valid mode name" do
    @reaction.mode = "invalid"
    assert_not @reaction.valid?
  end

  test "user_id should be present" do
    @reaction.user_id = nil
    assert_not @reaction.valid?
  end

  test "reactable_id should be present" do
    @reaction.reactable_id = nil
    assert_not @reaction.valid?
  end

  test "reactable_type should be present" do
    @reaction.reactable_type = " "
    assert_not @reaction.valid?
  end

  test "user_id, reactable_id, and reactable_type combos should be unique" do
    r = Reaction.new(mode: "like",
                     user_id: @user.id,
                     reactable_id: @post.id,
                     reactable_type: "Post")
    assert_not r.valid?
  end
end
