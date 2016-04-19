class Post < ActiveRecord::Base
  belongs_to :user

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :reactions, as: :reactable, dependent: :destroy

  default_scope -> { order(created_at: :desc) }

  mount_uploader :picture, PictureUploader

  validates :content, presence: true
  validates :user_id, presence: true
  validate  :picture_size

  private

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
