# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user_abilities
    else
      guest_abilities
    end
  end

  def user_abilities
    can :read, [Question, Profit]
    can :create, [Question, Answer, Comment]

    can [:update, :destroy], [Question, Answer] do |resource|
      user.author?(resource)
    end

    can [:vote_up, :vote_down], [Question, Answer] do |votable|
      !user.author?(votable)
    end

    can :destroy, ActiveStorage::Attachment do |att|
      user.author?(att.record)
    end

    can :destroy, Link do |link|
      user.author?(link.linkable)
    end

    can :best_answer, Answer do |answer|
      !user.author?(answer) && user.author?(answer.question)
    end
  end

  def guest_abilities
    can :read, [Question, Answer]
  end
end
