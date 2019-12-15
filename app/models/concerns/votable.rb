module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def vote_up(user)
    transaction do
      remove_all_votes(user)
      votes.create!(user: user, value: 1)
    end
  end

  def vote_down(user)
    transaction do
      remove_all_votes(user)
      votes.create!(user: user, value: -1)
    end
  end

  def total_votes
    votes.sum(:value)
  end

  private

  def remove_all_votes(user)
    votes.where(user_id: user).delete_all
  end
end
