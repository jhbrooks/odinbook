class User < ActiveRecord::Base
  has_one :profile

  has_many :sent_friend_requests, foreign_key: :sender_id,
                                  class_name: "FriendRequest"
  has_many :potential_passive_friends, through: :sent_friend_requests,
                                      source: :receiver
  has_many :received_friend_requests, foreign_key: :receiver_id,
                                      class_name: "FriendRequest"
  has_many :potential_active_friends, through: :received_friend_requests,
                                      source: :sender

  has_many :friendships, foreign_key: :active_friend_id,
                         class_name: "Friendship"
  has_many :friends, through: :friendships, source: :passive_friend

  has_many :posts
  has_many :comments
  has_many :reactions

  default_scope -> { order(:name) }

  validates :name, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, and :timeoutable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :omniauthable,
         omniauth_providers: [:facebook]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name

      user.create_profile
    end
  end

  def timeline
    friend_ids = "SELECT passive_friend_id FROM friendships
                  WHERE active_friend_id = :user_id"
    Post.where("user_id IN (#{friend_ids})
                OR user_id = :user_id", user_id: id)
  end
end
