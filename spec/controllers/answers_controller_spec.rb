require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  describe 'POST #create' do
    context 'with valid attributes' do
      it 'save a new answers to database' do
        expect { post :create, params: { answer: attributes_for(:answer) } }.to \
              change(Answer, :count).by(1)
      end
      it 'redirect to show view'
    end
    context 'with invalid attributes' do
      it 'does not save answer'
      it 're-renders new view'
    end
  end
end
