require 'rails_helper'

feature 'User can see gists for answer' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  given!(:answer) { create(:answer, body: 'text', question: question, user: user) }
  given!(:link_01) { create(:link, :gist, linkable: question.answers.first) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can see answer gist content on page' do
      expect(page).to have_content 'question_5'
    end
  end
end
