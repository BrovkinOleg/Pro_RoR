require 'rails_helper'

feature 'Create answer', %q{
  User who ask question can give answer on the question
} do

  given(:user) { create :user }
  given!(:question) { create :question, user: user }

  describe 'Authenticated user tries create answer' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'with valid attr'  do
      fill_in 'Add your answer', with: 'test answer'
      click_on 'Create'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'test answer'
      expect(current_path).to eq question_path(question)
    end

    scenario 'with not-valid attr'  do
      fill_in 'Add your answer', with: ''
      click_on 'Create'

      expect(page).to have_content 'Answer field can not be blank.'
      expect(current_path).to eq question_path(question)
    end
  end

  scenario 'Non-authenticated user tries to create answer' do
    visit question_path(question)

    expect(page).to have_no_button 'Create answer'
    expect(page).to have_content 'Sign_in or Sign_up if you want to leave an answer'
  end
end