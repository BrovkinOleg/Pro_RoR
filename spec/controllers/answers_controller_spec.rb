require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:user) { create :user }
  let(:question) { create :question, user: user }
  # before { sign_in(user) }

  describe 'POST #create' do
    before { sign_in(user) }
    context 'with valid attributes' do
      it 'saves the new answer to database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to \
        change(question.answers, :count).by(1)
      end

      it 'redirect to the questions#index' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not \
        change(Answer, :count)
      end

      it 'renders new_answer template' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'GET #new' do
    before { sign_in(user) }
    before { get :new, params: { question_id: question } }

    it 'assign a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    it 'render show new' do
      expect(response).to render_template :new
    end
  end
end
