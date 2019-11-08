require 'rails_helper'

  WRONG_EMAIL = 'wrong@test.com'
  WRONG_PASS = '11111111'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
} do

  given(:user) { create(:user) }

  background { visit new_user_session_path }

  describe 'Registered user tries to sign in with' do
    scenario 'right password and right email' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'

      expect(page).to have_content 'Signed in successfully.'
    end

    scenario 'right password and wrong email' do
      fill_in 'Email', with: WRONG_EMAIL
      fill_in 'Password', with: user.password
      click_on 'Log in'

      expect(page).to have_content 'Invalid Email or password.'
    end

    scenario 'wrong password and wrong email' do
      fill_in 'Email', with: WRONG_EMAIL
      fill_in 'Password', with: WRONG_PASS
      click_on 'Log in'

      expect(page).to have_content 'Invalid Email or password.'
    end
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: WRONG_EMAIL
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end