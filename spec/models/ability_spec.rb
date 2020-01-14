require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'Guest abilities' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should_not be_able_to :read, Profit }
    it { should_not be_able_to :manage, :all }
  end

  describe 'User abilities' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:question2) { create(:question, user: user2) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:answer2) { create(:answer, question: question, user: user2) }
    let(:answer3) { create(:answer, question: question2, user: user) }
    let!(:vote) { create(:vote, user: user, votable: question2) }

    describe 'View profit' do
      it { should be_able_to :read, Profit }
    end

    describe '#create' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }
    end

    describe '#update' do
      it { should be_able_to :update, question }
      it { should_not be_able_to :update, question2 }
      it { should be_able_to :update, answer }
      it { should_not be_able_to :update, answer2 }
    end

    describe '#destroy' do
      it { should be_able_to :destroy, question }
      it { should_not be_able_to :destroy, question2 }
      it { should be_able_to :destroy, answer }
      it { should_not be_able_to :destroy, answer2 }
      it { should be_able_to :destroy, build(:link, linkable: question) }
      it { should_not be_able_to :destroy, build(:link, linkable: question2) }
      it { should be_able_to :destroy, build(:link, linkable: answer) }
      it { should_not be_able_to :destroy, build(:link, linkable: answer2) }
      it {
        question.files.attach(create_file_blob)
        should be_able_to :destroy, question.files.first
      }
      it {
        answer.files.attach(create_file_blob)
        should be_able_to :destroy, answer.files.first
      }
      it {
        question2.files.attach(create_file_blob)
        should_not be_able_to :destroy, question2.files.first
      }
      it {
        answer2.files.attach(create_file_blob)
        should_not be_able_to :destroy, answer2.files.first
      }
    end

    describe '#vote' do
      it { should_not be_able_to :vote_up, answer }
      it { should_not be_able_to :vote_up, question }
      it { should_not be_able_to :vote_down, answer }
      it { should_not be_able_to :vote_down, question }

      it { should be_able_to :vote_up, answer2 }
      it { should be_able_to :vote_up, question2 }
      it { should be_able_to :vote_down, answer2 }
      it { should be_able_to :vote_down, question2 }
    end

    describe '#set best answer' do
      it { should be_able_to :best_answer, answer2 }
      it { should_not be_able_to :best_answer, answer }
      it { should_not be_able_to :best_answer, answer3 }
    end
  end
end
