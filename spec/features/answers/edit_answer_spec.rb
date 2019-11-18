require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes as an author of answer
  I'd like to be able to edit my answer
  } do

  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user author', js: true do
    background do
      sign_in(answer.user)
      visit question_path(answer.question)
      click_on 'Edit'
    end

    scenario 'edits his answer' do
      within '.answers' do
        fill_in 'Body_Edit', with: 'edited answer'
        click_on 'Save'

        expect(page).to have_no_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to have_no_selector('textarea')
      end
    end

    scenario 'edits his answer with errors' do
      within '.answers' do
        fill_in 'Body_Edit', with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Authenticated not author' do
    background do
      sign_in(second_user)
      visit question_path(answer.question)
    end

    scenario 'tries to edit not his answer', js: true do
      expect(page).to have_no_link('Edit')
    end

  end

  describe 'Unauthenticated user' do
    background do
      visit questions_path(question)
    end

    scenario 'can not edit answer' do
      visit questions_path(question)

      expect(page).to have_no_link 'Edit'
    end
  end
end