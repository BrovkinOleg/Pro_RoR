require 'rails_helper'

feature 'User can log out' do

  given(:user) { create :user }
  background do
    visit root_path
    sign_in(user)
    click_on 'Sign out'
  end

  scenario 'Registered and authorized user try to sign out' do
    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Unregistered user has link Sign_in and has not link Sign_out' do
    expect(page).to have_link 'Sign in'
    expect(page).to have_no_link 'Sign out'
  end
end
