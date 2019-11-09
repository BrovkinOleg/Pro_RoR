require 'rails_helper'

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
      fill_in 'Email', with: 'wrong@test.com'
      fill_in 'Password', with: user.password
      click_on 'Log in'

      expect(page).to have_content 'Invalid Email or password.'
    end

    scenario 'wrong password and wrong email' do
      fill_in 'Email', with: 'wrong@test.com'
      fill_in 'Password', with: 'wrong_password'
      click_on 'Log in'

      expect(page).to have_content 'Invalid Email or password.'
    end
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end