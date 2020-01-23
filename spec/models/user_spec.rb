require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:subscribers).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.find_by_auth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123123') }

    context 'user has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123123')
        expect(User.find_by_auth(auth)).to eq user
      end
    end
  end

  describe '.find_or_create' do
    let!(:user) { create(:user, email: 'test@test.com') }

    it 'find user' do
      expect(User.find_or_create('test@test.com')).to eq user
    end

    it 'create user' do
      expect(User.find_or_create('new@test.com')).to_not eq nil
    end
  end

  describe '.random_user!' do
    it 'return random user' do
      expect(User.find_or_create('new@test.com')).to_not eq nil
    end
  end

  describe 'author?' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }

    context 'user is question author' do
      it 'should return true' do
        expect(user).to be_author(question)
      end
    end

    context 'user is not question author' do
      it 'should return true' do
        expect(user2).to_not be_author(question)
      end
    end

    context 'user is answer author' do
      it 'should return true' do
        expect(user).to be_author(answer)
      end
    end

    context 'user is not answer author' do
      it 'should return true' do
        expect(user2).to_not be_author(answer)
      end
    end
  end

  describe 'find_subscriber' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'find subscriber for user' do
      expect(user.find_subscriber).to eq user.subscribers.first
    end
  end

  describe 'subscribed?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    subject { user.subscribed?(question) }
    it 'user has subscription for question' do
      is_expected.to be_truthy
    end
  end

  describe 'not subscribed?' do
    let(:user) { create(:user) }
    let(:new_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    subject { new_user.subscribed?(question) }
    it 'user has not subscription for question' do
      is_expected.to be_falsey
    end
  end
end
