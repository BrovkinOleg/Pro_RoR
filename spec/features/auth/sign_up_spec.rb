require 'rails_helper'

feature 'User can sign up (register)', %q{
  In order to be able to ask a question
  User must be able sign up (register)
} do

  given(:user) { create :user }

  scenario 'New user try to sign up' do
    visit new_user_registration_path
    fill_in 'Email', with: 'test_sign_up@test.com'
    fill_in 'Password', with: 'qwerty123'
    fill_in 'Password confirmation', with: 'qwerty123'
    click_on 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'

    visit new_user_session_path
    expect(current_path).to eq root_path
  end

  scenario 'Registered user try to sign up' do
    sign_up(user)

    expect(page).to have_content 'Email has already been taken'
  end
end
