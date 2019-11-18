require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question, user: user }
  let(:questions) { create_list(:question, 3, user: user) }

  describe 'GET #index' do
    context 'Unregistered user' do
      before { get :index }
      it 'populates an array of all questions' do
        expect(assigns(:questions)).to match_array(questions)
      end
      it 'renders index view' do
        expect(response).to render_template :index
      end
    end

    context 'Registered user' do
      before { sign_in(user) }
      before { get :index }
      it 'populates an array of all questions' do
        expect(assigns(:questions)).to match_array(questions)
      end
      it 'renders index view' do
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET #new' do
    context 'Registered user' do
      before { sign_in(user) }
      before { get :new }

      it 'assigns a new Question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'render new view' do
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #show' do
    context 'Unregistered user' do
      before { get :show, params: {id: question} }
      it 'Assigns a requested question to @question' do
        expect(assigns(:question)).to eq question
      end
      it 'render show view' do
        expect(response).to render_template :show
      end
    end

    context 'Registered user' do
      before { sign_in(user) }
      before { get :show, params: { id: question } }

      it 'assign requested question to @question' do
        expect(assigns(:question)).to eq(question)
      end
      it 'renders show view' do
        expect(response).to render_template :show
      end
    end
  end

  describe 'GET #edit' do
    context 'Registered user' do
      before { sign_in(user) }
      before { get :edit, params: { id: question } }

      it 'assign requested question to @question' do
        expect(assigns(:question)).to eq(question)
      end

      it 'render edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'POST #create' do
    context 'Registered user' do
      before { sign_in(user) }
      context 'with valid attributes' do

        it 'save a new question to database' do
          expect { post :create, params: { question: attributes_for(:question) } }.to \
                change(Question, :count).by(1)
        end

        it 'redirect to show view' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do

        it 'does not save question' do
          expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
        end

        it 're-renders new view' do
          post :create, params: { question: attributes_for(:question, :invalid) }
          expect(response).to render_template :new
        end
      end
    end

    context 'Unregistered user' do

      it 'does not save question' do
        expect { post :create, params: { question: attributes_for(:question) } }.to_not change(Question, :count)
      end

      it 'redirect to new user session path' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Unregistered user' do
      let!(:question) { create :question, user: user }
      it 'not deletes the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to sign_in' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'Registered not author' do
      let(:not_author) { create :user }
      before { sign_in(not_author) }
      let!(:question) { create :question, user: user }

      it 'try deletes the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'Registered author' do
      let(:author) { create :user }
      before { sign_in(author) }
      let!(:question) { create :question, user: author }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end
  end

  describe 'PATCH #update' do
    context 'Unregistered user' do

      it 'not changes attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }
        question.reload
        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
        expect(question.user).to eq user
      end

      it 'redirect to new user session path' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to new_user_session_path
      end

    end

    context 'Registered not author' do
      let(:not_author) { create :user }
      before { sign_in(not_author) }

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
        question.reload
        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
        expect(question.user).to eq user
      end

      it 'redirect to question_path' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
        expect(response).to redirect_to question
      end
    end

    context 'Registered user' do
      before { sign_in(user) }
      context 'with valid attributes' do

        it 'assigns the requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
          expect(question.user).to eq user
        end

        it 'redirects to updated question' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(response).to redirect_to question
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

        it 'does not change question' do
          question.reload

          expect(question.title).to eq 'MyString'
          expect(question.body).to eq 'MyText'
        end

        it 'redirect_to question' do

          expect(response).to redirect_to question
        end
      end
    end
  end
end
