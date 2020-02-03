
class Answer < ApplicationRecord
  include LinksAssociations
  include Votable
  include HasComments

  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true

  default_scope { order(best: :desc).order(:created_at) }

  after_commit :send_inform_email, on: :create

  def best_answer!
    transaction do
      question.answers.update_all(best: false)
      self.update!(best: true)
      question.profit&.update!(user: user)
    end
  end

  private

  def send_inform_email
    NotifyNewAnswerJob.perform_later(self)
  end
end
