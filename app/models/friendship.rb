class Friendship < ActiveRecord::Base
  belongs_to :active_friend, class_name: "User"
  belongs_to :passive_friend, class_name: "User"

  validates :active_friend_id, presence: true
  validates :passive_friend_id, presence: true
  validates :active_friend_id, uniqueness: { scope: :passive_friend_id }
  validate :not_self

  def not_self
    if active_friend_id == passive_friend_id
      errors.add(:not_self, "can't target self")
    end
  end
end
