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
    guest_abilities

    can :read, [Profit]
    can :create, [Question, Answer, Comment, Subscriber]
    can :destroy, Subscriber, id: user.id

    can [:update, :destroy], [Question, Answer] do |resource|
      user.author?(resource)
    end

    can [:vote_up, :vote_down], [Question, Answer] do |votable|
      !user.author?(votable)
    end

    can :destroy, ActiveStorage::Attachment do |attachment|
      user.author?(attachment.record)
    end

    can :destroy, Link do |link|
      user.author?(link.linkable)
    end

    can :best_answer, Answer do |answer|
      !user.author?(answer) && user.author?(answer.question)
    end
  end

  def guest_abilities
    can :read, [Question, Answer, Comment]
  end
end
