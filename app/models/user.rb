class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:github, :vkontakte]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :profits, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscribers, dependent: :destroy

  def self.find_for_oauth(auth, email)
    FindForOauthService.new(auth, email).call
  end

  def self.find_by_auth(auth)
    Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)&.user
  end

  def self.find_or_create(email)
    user = User.find_by(email: email)
    user || random_user!(email)
  end

  def self.random_user!(email)
    password = Devise.friendly_token[0, 20]
    User.create!(email: email, password: password, password_confirmation: password)
  end

  def author?(object)
    self.id == object.user_id
  end

  def find_subscriber
    Subscriber.find_by(user_id: self.id)
  end

  def subscribed?(question)
    subscribers.exists?(question: question)
  end
end