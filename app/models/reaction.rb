class Reaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :reactable, polymorphic: true

  validates :mode, presence: true,
                   inclusion: { in: %w(like),
                                message: "%{value} is not a valid mode" }
  validates :user_id, presence: true,
                      uniqueness: { scope: [:reactable_id, :reactable_type] }
  validates :reactable_id, presence: true
  validates :reactable_type, presence: true
end
