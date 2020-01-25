
require 'rails_helper'

RSpec.describe Question, type: :model do
  include_examples 'links associations'

  it_behaves_like Votable do
    let(:user) { create(:user) }
    let(:second_user) { create(:user) }
    let(:third_user) { create(:user) }
    let(:votable) { create(:question, user: user) }
  end

  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:subscribers).dependent(:destroy) }

  it 'have many attached file' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'create_subscribe!' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    it 'create subscribe after create question' do
      expect(question.subscribers.first.user_id).to eq user.id
    end
  end
end
