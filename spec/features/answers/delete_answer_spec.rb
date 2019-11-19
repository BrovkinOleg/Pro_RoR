require 'rails_helper'

feature 'Delete Answer' do

  given(:user) { create :user }
  given(:another_user) { create :user }
  given!(:question) { create :question, user: user }
  given!(:answer) { create :answer, question: question, user: user }

  describe 'Authenticated user', js: true do
    scenario 'author delete his answer' do
      sign_in(user)
      visit question_path(question)
      expect(page).to have_content answer.body
      click_on 'Delete'

      expect(page).to have_no_content answer.body
    end

    scenario 'another user can not delete answer' do
      sign_in(user)
      visit question_path(question)

      expect(page).to have_no_button 'Delete'
    end
  end
end
