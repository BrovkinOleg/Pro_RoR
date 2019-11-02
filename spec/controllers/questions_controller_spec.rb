require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }
    before { get :show, params: { id: question } }

    it 'assign requested question to @question' do
      expect(assigns(:question)).to eq(question)
    end
    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  # describe 'POST #create' do
  #
  #   it 'user can create question'
  #   it 'render created question view'
  # end
end