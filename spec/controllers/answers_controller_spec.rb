require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:user) { create :user }
  let(:question) { create :question, user: user }

  describe 'POST #create' do
    context 'Unregistered user' do

      it 'does not create answer' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to_not \
          change(question.answers, :count)
      end

      it 'redirects to login page' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'Registered user' do
      before { sign_in(user) }
      context 'with valid attributes' do

        it 'saves the new answer to database' do
          expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to \
          change(question.answers, :count).by(1)
        end

        it 'renders template :create' do
          post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
      let!(:answers) { create_list(:answer, 2, body: 'text', question: question, user: user) }

        it 'does not save the question' do
          expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not \
          change(Answer, :count)
        end

        it 'renders template :create' do
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js
          expect(response).to render_template :create
        end
      end
    end
  end

  describe 'GET #new' do
    context 'Registered user' do
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

  describe 'GET #new' do
    context 'Unregistered user' do
      before { get :new, params: { question_id: question } }

      it 'redirect to sign_in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
