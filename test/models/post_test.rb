require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @post = posts(:one)
    @last_by_created_at = posts(:last_by_created_at)
  end

  test "should be valid" do
    assert @post.valid?
  end

  test "content should be present" do
    @post.content = " "
    assert_not @post.valid?
  end

  test "user_id should be present" do
    @post.user_id = nil
    assert_not @post.valid?
  end

  test "should be sorted by created_at in descending order" do
    assert_equal @last_by_created_at, Post.last
  end
end
