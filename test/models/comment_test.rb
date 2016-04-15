require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @comment = comments(:one)
    @most_recent = comments(:most_recent)
  end

  test "should be valid" do
    assert @comment.valid?
  end

  test "content should be present" do
    @comment.content = " "
    assert_not @comment.valid?
  end

  test "user_id should be present" do
    @comment.user_id = nil
    assert_not @comment.valid?
  end

  test "commentable_id should be present" do
    @comment.commentable_id = nil
    assert_not @comment.valid?
  end

  test "commentable_type should be present" do
    @comment.commentable_type = " "
    assert_not @comment.valid?
  end

  test "should be sorted by created_at in ascending order" do
    assert_equal @most_recent, Comment.last
  end
end
