require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like Voted do
    let(:new_user) { create(:user) }
    let(:votable) { create(:question, user: user) }
  end

  let(:user) { create :user }
  let(:question) { create :question, user: user }
  let(:questions) { create_list(:question, 2, user: user) }

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

      it 'assigns new @question.link' do
        expect(assigns(:question).links.first).to be_a_new(Link)
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

      it 'assigns new answer for question' do
        expect(assigns(:answer)).to be_a_new(Answer)
      end

      it 'assigns new link for answer' do
        expect(assigns(:answer).links.first).to be_a_new(Link)
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

        it 'can broadcasts to question channel' do
          expect { post :create, params: { question: attributes_for(:question) } }.to \
                 have_broadcasted_to('questions_channel')
        end

        it 'save a new question to database' do
          expect { post :create, params: { question: attributes_for(:question) } }.to \
                change(Question, :count).by(1)
        end

        it 'redirect to show view' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'add link' do
        before { sign_in(user) }
        it 'saves the new question in the database' do
          expect { post :create, params: { question: { title: 'MyTitle', body: 'MyBody',
             links_attributes: { '0' => { name: 'LinkName', url: 'https://www.linkexample.com/',
                 _destroy: false } } } } }.to change(user.questions, :count).by(1)
        end

        it 'redirects to index view' do
          post :create, params: { question: { title: 'MyTitle', body: 'MyBody',
              links_attributes: { '0' => { name: 'LinkName', url: 'https://www.linkexample.com/',
                                           _destroy: false } } } }
          expect(response).to redirect_to assigns(:question)
        end

        it 'renders a flash message' do
          post :create, params: { question: { title: 'MyTitle', body: 'MyBody',
              links_attributes: { '0' => { name: 'LinkName', url: 'https://www.linkexample.com/',
                                           _destroy: false } } } }
          expect(flash[:notice]).to eq 'Your question successfully created.'
        end
      end

      context 'with invalid attributes' do

        it 'can not broadcasts to question channel' do
          expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not \
                 have_broadcasted_to('questions_channel')
        end

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

      it 'can not broadcasts to question channel' do
        expect { post :create, params: { question: attributes_for(:question) } }.to_not \
                 have_broadcasted_to('questions_channel')
      end

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
    let!(:question_with_link) { create(:question, user: user) }
    let!(:link) { create(:link, linkable: question_with_link) }
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

        it 'deletes link from question' do
          patch :update, params: { id: question_with_link, question: { title: question_with_link.title,
                body: question_with_link.body, links_attributes: { '0' => { name: link.name, url: link.url,
                         _destroy: true, id: link } } } }, format: :js
          question_with_link.reload

          expect(question_with_link.links.count).to be_zero
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
