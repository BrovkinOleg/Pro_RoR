
class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  default_scope { order(best: :desc).order(:created_at) }

  def best_answer!
    transaction do
      question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end
end
