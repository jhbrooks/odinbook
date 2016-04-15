class Post < ActiveRecord::Base
  belongs_to :user

  has_many :comments, as: :commentable

  default_scope -> { order(created_at: :desc) }

  validates :content, presence: true
  validates :user_id, presence: true
end
