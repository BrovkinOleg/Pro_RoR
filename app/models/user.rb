class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_one :profit, dependent: :destroy

  accepts_nested_attributes_for :profit, reject_if: :all_blank, allow_destroy: true

  def author?(object)
    self.id == object.user_id
  end
end
