require 'rails_helper'

feature 'User can add profits to new question' do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit new_question_path
      fill_in 'Title', with: 'question'
      fill_in 'Body', with: 'add_profit'
      attach_file 'question[profit_attributes][image]', "#{Rails.root}/app/assets/images/Badge_01.png"
    end

    scenario 'add profits to new question without name' do
      fill_in 'Profit_name', with: ''
      click_on 'Ask'

      expect(page).to have_content "Profit name can't be blank"
    end

    scenario 'add profits to new question with name and image' do
      fill_in 'Profit_name', with: 'Your_profit'
      attach_file 'question[profit_attributes][image]', "#{Rails.root}/app/assets/images/Badge_01.png"
      click_on 'Ask'

      expect(page).to have_content 'add_profit'
      expect(page).to have_content 'Your question successfully created.'
      within '.profits' do
        expect(page).to have_content 'Your_profit'
        expect(page).to have_css('img')
      end
    end
  end
end
