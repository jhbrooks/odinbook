class User < ActiveRecord::Base
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
    end
  end
end
