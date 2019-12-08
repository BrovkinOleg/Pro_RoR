require 'rails_helper'

feature 'User can view a list of profits' do
  given(:user_01) { create(:user) }
  given(:user_02) { create(:user) }

  given(:question_01) { create(:question, user: user_02) }
  given(:question_02) { create(:question, user: user_02) }
  given(:question_03) { create(:question, user: user_02) }

  given!(:profit_0) { create(:profit, question: question_01, user: user_01) }
  given!(:profit_1) { create(:profit, question: question_02, user: user_01) }
  given!(:profit_2) { create(:profit, question: question_03, user: user_02) }

  describe 'Authenticated user' do
    background do
      sign_in(user_01)
      visit root_path
    end

    scenario 'see list of profits' do
      click_on 'My profits'

      expect(page).to have_content profit_0.name
      expect(page).to have_content profit_1.name
      expect(page).to have_no_content profit_2.name
    end
  end

  scenario "Unauthenticated can not see link 'My profits'" do
    visit root_path
    expect(page).to have_no_link('My profits')
  end
end
