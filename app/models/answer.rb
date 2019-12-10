
class Answer < ApplicationRecord
  include LinksAssociations
  include ModelVoted

  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true

  default_scope { order(best: :desc).order(:created_at) }

  def best_answer!
    transaction do
      question.answers.update_all(best: false)
      self.update!(best: true)
      question.profit&.update!(user: user)
    end
  end
end
