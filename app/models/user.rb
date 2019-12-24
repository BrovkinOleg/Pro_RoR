class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github, :vkontakte]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :profits, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  def self.find_for_oauth(auth, email)
    FindForOauthService.new(auth, email).call
  end

  def self.find_by_auth(auth)
    Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)&.user
  end

  def self.find_or_create(email)
    user = User.find_by(email: email)
    user || create_user_with_rand_password!(email)
  end

  def self.create_user_with_rand_password!(email)
    password = Devise.friendly_token[0, 20]
    User.create!(email: email, password: password, password_confirmation: password)
  end

  def author?(object)
    self.id == object.user_id
  end
end