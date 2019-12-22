
require 'rails_helper'

RSpec.describe Answer, type: :model do
  include_examples 'links associations'

  it_behaves_like Votable do
    let(:user) { create(:user) }
    let(:second_user) { create(:user) }
    let(:third_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:votable) { create(:answer, question: question, user: user) }
  end

  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }
  it { should_not validate_presence_of :best}

  it 'have many attached file' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
