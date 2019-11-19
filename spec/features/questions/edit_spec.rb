require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
  " do
  given!(:user) { create(:user) }
  given(:new_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit root_path
      click_on 'Edit question'
    end

    scenario 'edits his own question', js: true do
      expect(page).to have_content 'MyString'
      expect(page).to have_content 'MyText'
      fill_in 'Edit title', with: 'edited title'
      fill_in 'Edit body', with: 'edited body'
      click_on 'Save'
      question.reload
      expect(question.body).to eq 'edited body'
      expect(question.title).to eq 'edited title'
      expect(page).to have_no_content question.title
      expect(page).to have_no_content question.body
    end

    scenario 'edits his question with errors' do
      fill_in 'Edit title', with: ''
      fill_in 'Edit body', with: ''
      click_on 'Save'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Authenticated not author', js: true do
    background do
      sign_in(new_user)
    end

    scenario 'tries to edit not his question' do
      visit root_path

      expect(page).to have_no_link('Edit question')
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario 'can not edit question' do
      visit root_path

      expect(page).to have_no_link 'Edit question'
    end
  end
end
