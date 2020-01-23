
class Question < ApplicationRecord
  include LinksAssociations
  include Votable
  include HasComments

  has_many :answers, dependent: :destroy
  has_one :profit, dependent: :destroy
  has_many :subscribers, dependent: :destroy

  belongs_to :user

  after_create :create_subscribe!

  has_many_attached :files

  accepts_nested_attributes_for :profit, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  private

  def create_subscribe!
    subscribers.create!(user: user)
  end
end
