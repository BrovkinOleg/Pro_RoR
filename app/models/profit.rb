class Profit < ApplicationRecord
  belongs_to :question, touch: true
  belongs_to :user, optional: true

  has_one_attached :image

  validates :name, presence: true
end
