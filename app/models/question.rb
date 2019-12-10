
class Question < ApplicationRecord
  include LinksAssociations
  include ModelVoted

  has_many :answers, dependent: :destroy
  has_one :profit, dependent: :destroy

  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :profit, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

end
