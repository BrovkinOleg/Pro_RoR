 require 'rails_helper'

 feature 'User can add links to question' do
   given!(:user) { create(:user) }
   given(:url_one) { 'https://boxbox.ru/' }
   given(:url_two) { 'https://google.com' }

   describe 'Authenticated user adds', js: true do
     background do
       sign_in(user)
       visit new_question_path
       fill_in 'Title', with: 'Test question'
       fill_in 'Body', with: 'text text text'
       fill_in 'Link name', with: 'url_one'
     end

     scenario 'add first link when asks question' do
       fill_in 'Url', with: url_one
       click_on 'Ask'

       expect(page).to have_content 'Test question'
       expect(page).to have_link 'url_one', href: url_one
     end

     scenario 'add second link when asks question' do
       fill_in 'Url', with: url_one
       click_on 'add link'
       within all('.nested-fields')[1] do
         fill_in 'Link name', with: 'url_two'
         fill_in 'Url', with: url_two
       end
       click_on 'Ask'

       expect(page).to have_content 'Test question'
       expect(page).to have_link 'url_one', href: url_one
       expect(page).to have_link 'url_two', href: url_two
     end

     scenario 'try add invalid link' do
       fill_in 'Link name', with: 'url_one'
       fill_in 'Url', with: 'invalid_link'
       click_on 'Ask'

       expect(page).to have_no_link 'url_one', href: 'invalid_link'
       expect(page).to have_content 'Links url is invalid'
     end
   end
 end
