require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let!(:user) { create :user }
  let!(:author) { create :user }
  let!(:question) { create(:question, user: author) }
  let!(:second_question) { create(:question, user: author) }

  describe 'DELETE #destroy' do
    context 'Authenticated author' do
      before do
        sign_in(author)
        question.files.attach(create_file_blob)
      end

      it 'can delete your file from table' do
        expect { delete :destroy, params: { id: question.files[0] }, format: :js }.to \
        change(question.files, :count).by(-1)
      end

      it 'renders destroy template' do
        expect { delete :destroy, params: { id: question.files[0] }, format: :js }.to \
        change(question.files, :count).by(-1)
        expect(response).to render_template :destroy
      end
    end

    context 'Authenticated not author' do
      before do
        sign_in(user)
        second_question.files.attach(create_file_blob)
      end

      it 'can not delete file' do
        expect { delete :destroy, params: { id: second_question.files[0] }, format: :js }.not_to \
        change(second_question.files, :count)
        expect(response).to redirect_to root_path
      end
    end

    context 'Unauthenticated user' do
      before { question.files.attach(create_file_blob) }

      it 'can not delete file and returns 401 status' do
        expect { delete :destroy, params: { id: question.files[0] }, format: :js }.not_to \
        change(question.files, :count)
        expect(response).to have_http_status(401)
      end
    end
  end
end
