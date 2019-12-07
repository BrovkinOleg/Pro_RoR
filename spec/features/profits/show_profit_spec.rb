require 'rails_helper'

feature 'User can view a list of profits' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:profit) { create(:profit, question: question, user: user) }

  given(:second_user) { create(:user) }
  given(:second_question) { create(:question, user: second_user) }
  given!(:second_profit) { create(:profit, question: second_question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit root_path
    end

    scenario 'see list of profits' do
      click_on 'My profits'
      expect(page).to have_content profit.name
      expect(page).to have_content profit.question.title
      expect(page).to have_content second_profit.name
      expect(page).to have_content second_profit.question.title
    end

    scenario 'can not see not his profits' do
      second_profit.update(user: second_user)
      click_on 'My profits'

      expect(page).to have_no_content second_profit.name
    end
  end

  scenario "Unauthenticated can not see link 'My profits'" do
    visit root_path
    expect(page).to have_no_link('My profits')
  end
end
