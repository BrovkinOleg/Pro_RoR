require 'rails_helper'

feature 'User can see list of questions' do
  given!(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, user: user) }
  background { visit root_path }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
    end

    scenario 'can see list of questions' do
      within '.questions' do
        questions.each do |question|
          expect(page).to have_content question.title
        end
      end
    end
  end

  scenario 'Unauthenticated user can see list of questions' do
    within '.questions' do
      questions.each do |question|
        expect(page).to have_content question.title
      end
    end
  end
end
