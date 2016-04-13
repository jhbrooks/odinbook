class FriendRequest < ActiveRecord::Base
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  validates :sender_id, presence: true
  validates :receiver_id, presence: true
  validates :sender_id, uniqueness: { scope: :receiver_id }
  validate :not_self

  def not_self
    errors.add(:not_self, "can't target self") if sender_id == receiver_id
  end
end
