class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :profits, dependent: :destroy
  has_many :votes, dependent: :destroy

  def author?(object)
    self.id == object.user_id
  end
end
