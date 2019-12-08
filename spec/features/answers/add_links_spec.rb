require 'rails_helper'

feature 'User can add links to answer' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:url) { 'https://google.com' }
  given(:second_url) { 'https://boxbox.ru' }

  describe 'Authenticated user can', js: true do
    background do
      sign_in(user)
      visit question_path(question)
      fill_in 'Add your answer', with: 'my_answer'
      click_on 'add link'

      fill_in 'Link name', with: 'url_one'
      fill_in 'Url', with: url
      click_on 'Create answer'
    end

    scenario 'adds link for that question' do
      expect(page).to have_link 'url_one', href: url
    end

    scenario 'delete link for that question' do
      expect(page).to have_link 'url_one', href: url

      click_on 'Edit'
      click_on 'delete link'
      click_on 'Save'
      expect(page).to_not have_link 'url_one', href: url
    end

    scenario 'try add invalid link' do
      click_on 'Edit'
      fill_in 'Url', with: 'invalid/link'
      click_on 'Save'

      expect(page).to have_no_link 'My url', href: 'invalid/link'
      expect(page).to have_content 'Links url is invalid'
    end
  end
end
