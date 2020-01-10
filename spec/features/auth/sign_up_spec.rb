require 'rails_helper'

feature 'User can sign up (register)' do

  given(:user) { create :user }

  scenario 'New user try to sign up' do
    visit new_user_registration_path
    fill_in 'Email', with: 'test_sign_up@test.com'
    fill_in 'Password', with: 'qwerty123'
    fill_in 'Password confirmation', with: 'qwerty123'
    click_on 'Sign up'

    open_email 'test_sign_up@test.com'

    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed'
  end

  scenario 'Registered user try to sign up' do
    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end

  describe 'User left blank some fields in form' do
    background do
      visit new_user_registration_path
      fill_in 'Email', with: ''
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password_confirmation
    end
    scenario 'Email is blank' do
      click_on 'Sign up'
      expect(page).to have_content "Email can't be blank"
    end

    scenario 'Password is blank' do
      fill_in 'Password', with: ''
      click_on 'Sign up'
      expect(page).to have_content "Password can't be blank"
    end

    scenario 'Password confirmation is blank' do
      fill_in 'Password confirmation', with: ''
      click_on 'Sign up'
      expect(page).to have_content "Password confirmation doesn't match Password"
    end
  end
end
