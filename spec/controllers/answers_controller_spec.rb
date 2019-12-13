
require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:user) { create :user }
  let(:new_user) { create :user }
  let(:question) { create :question, user: user }
  let!(:profit) { create(:profit, question: question) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:new_answer) { create(:answer, question: question, user: new_user) }

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

        it 'answer is linked to user' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to \
          change(user.answers, :count).by(1)
        end

        it 'renders template :create' do
          post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with link' do
        before { sign_in(user) }
        it 'saves question.answer in database' do
          expect { post :create, params: { question_id: question, answer: { body: 'MyBody', \
                links_attributes: { '0' => { name: 'LinkName', url: 'https://www.linkexample.com/', \
                                  _destroy: false } } } }, format: :js }.to change(question.answers, :count).by(1)
        end

        it 'answer is linked to user' do
          expect { post :create, params: { question_id: question, answer: { body: 'MyBody',
                links_attributes: { '0' => { name: 'LinkName',  url: 'https://www.linkexample.com/', \
                                  _destroy: false } } } }, format: :js }.to change(user.answers, :count).by(1)
        end

        it 'renders create template' do
          post :create, params: { question_id: question, answer: { body: 'MyBody',
              links_attributes: { '0' => { name: 'LinkName', url: 'https://www.linkexample.com/', \
                                           _destroy: false } } } }, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
      let!(:answers) { create_list(:answer, 2, body: 'text', question: question, user: user) }

        it 'does not save the question' do
          expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, \
          format: :js }.to_not change(Answer, :count)
        end

        it 'renders template :create' do
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js
          expect(response).to render_template :create
        end
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

  describe 'DELETE #destroy' do

    context 'authenticated user' do
      before { sign_in(user) }

      it 'deletes his own answer' do
        expect { delete :destroy, params: { id: answer.id, question_id: question.id },
                 format: :js }.to change(Answer, :count).by(-1)
      end

      it 'and renders template destroy' do
        delete :destroy, params: { id: answer, question_id: question }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'authenticated user' do
      before { sign_in(user) }

      it 'tries to delete not his answer' do
        expect { delete :destroy, params: { id: new_answer, question_id: question.id },
                 format: :js }.to_not change(Answer, :count)
      end

      it 'and renders template destroy' do
        delete :destroy, params: { id: new_answer, question_id: question }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'guest, not authenticated user' do
      it 'does not delete answer' do
        expect { delete :destroy, params: { id: answer, question_id: question },
                 format: :js }.to_not change(Answer, :count)
      end

      it 'returns 401 status' do
        delete :destroy, params: { id: answer, question_id: question }, format: :js
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'PATCH #update' do

    context 'Unauthenticated user, guest' do
      it 'does not update answer' do
        expect { patch :update, params: { id: answer, question_id: question,
                 answer: { body: 'new body' } }, format: :js}.to_not change(answer.reload, :body)
      end

      it 'returns 401 status' do
        patch :update,  params: { id: answer, question_id: question,
        answer: { body: 'new body' } }, format: :js

        expect(response).to have_http_status(401)
      end
    end

    context 'Authenticated user edit answer' do
      before { sign_in(user) }
      context 'with valid attributes' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer, question_id: question, answer: { body: 'new body' } },
                format: :js
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders template update' do
          patch :update, params: { id: answer, question_id: question, answer: { body: 'new body' } },
                format: :js
          expect(response).to render_template :update
        end
      end

      context 'update link attributes' do
        let!(:answer_with_link) { create(:answer, question: question, user: user) }
        let!(:link) { create(:link, linkable: answer_with_link) }
        before { sign_in(user) }

        it 'deletes answer link' do
          expect(answer_with_link.links).not_to be_empty

          patch :update, params: { id: answer_with_link, question_id: question, answer: \
            { links_attributes: { '0': { name: link.name, url: link.url, \
              _destroy: true, id: link.id } } }, format: :js }
          answer_with_link.reload

          expect(answer_with_link.links).to be_empty
        end

        it 'renders template update' do
          patch :update, params: { id: answer_with_link, question_id: question, \
                answer: { body: 'MyBody', links_attributes: { '0' => { name: link.name, url: link.url, \
                          _destroy: true, id: link } } } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          expect { patch :update, params: { id: answer, question_id: question,
                   answer: attributes_for(:answer, :invalid) }, format: :js}.to_not change(answer.reload, :body)
        end

        it 'renders template update' do
          patch :update, params:
              { id: answer, question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'Not author' do

        it 'tries to edit answer' do
          expect { patch :update, params: { id: new_answer, question_id: question,
                   new_answer: { body: 'new body' } }, format: :js}.to_not change(new_answer.reload, :body)
        end

        it 'renders template update' do
          patch :update, params: { id: new_answer, question_id: question,
                 new_answer: { body: 'new body' } }, format: :js
          expect(response).to render_template :update
        end
      end
    end
  end

  describe 'PATCH #best_answer' do
    context 'Authenticated author of the question' do
      before { sign_in(user) }

      it 'can set best_answer' do
        patch :best_answer, params: { id: answer, question_id: question,
             answer: { best: true } }, format: :js
        answer.reload

        expect(answer).to be_best
      end

      it 'sets profits to user' do
        patch :best_answer, params: { id: answer, question_id: question,
             answer: { best: true } }, format: :js
        answer.reload
        profit.reload

        expect(answer.user).to eq profit.user
      end

      it 'renders best_answer view' do
        patch :best_answer, params: { id: answer, question_id: question,
              answer: { best: true } }, format: :js

        expect(response).to render_template :best_answer
      end
    end

    context 'Authenticated not author of the question' do
      before { sign_in(new_user) }

      it 'does not change best_answer' do
        patch :best_answer, params: { id: answer, question_id: question,
               answer: { best: true } }, format: :js
        answer.reload

        expect(answer).to_not be_best
      end

      it 'renders template best_answer' do
        patch :best_answer, params: { id: answer, question_id: question,
               answer: { best: true } }, format: :js
        answer.reload

        expect(response).to render_template :best_answer
      end
    end

    context 'Unauthenticated user' do
      it 'does not change best_answer' do
        patch :best_answer, params: { id: answer, question_id: question,
               answer: { best: true } }, format: :js
        answer.reload

        expect(answer).to_not be_best
      end

      it 'returns 401 status' do
        patch :best_answer, params: { id: answer, question_id: question,
              answer: { best: true } }, format: :js
        expect(response).to have_http_status(401)
      end
    end
  end
end
