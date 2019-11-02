require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
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
    before { get :show, params: { id: question } }

    it 'assign requested question to @question' do
      expect(assigns(:question)).to eq(question)
    end
    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: question } }

    it 'assign requested question to @question' do
      expect(assigns(:question)).to eq(question)
    end
    it 'render show edit' do
      expect(response).to render_template :edit
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assign a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end
    it 'render show new' do
      expect(response).to render_template :new
    end
  end

  # describe 'POST #create' do
  #
  #   it 'user can create question'
  #   it 'render created question view'
  # end
end
