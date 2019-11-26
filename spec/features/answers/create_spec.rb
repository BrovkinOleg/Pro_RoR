require 'rails_helper'

feature 'Create answer', %q{
  User who ask question can give answer on the question
} do

  given(:user) { create :user }
  given!(:question) { create :question, user: user }

  describe 'Authenticated user tries create answer', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'with valid attr'  do
      fill_in 'Add your answer', with: 'test answer'
      click_on 'Create answer'

      expect(page).to have_content 'test answer'
      expect(current_path).to eq question_path(question)
    end

    scenario 'with not-valid attr' do
      fill_in 'Add your answer', with: ''
      click_on 'Create answer'

      expect(current_path).to eq question_path(question)
    end

    scenario 'can create answer with attached file' do
      fill_in 'Add your answer', with: 'my_answer'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create answer'
      click_on 'Edit'

      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  scenario 'Non-authenticated user tries to create answer' do
    visit question_path(question)

    expect(page).to have_no_button 'Create answer'
    expect(page).to have_content 'Sign_in or Sign_up if you want to leave an answer'
  end
end