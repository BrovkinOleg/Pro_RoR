require 'rails_helper'

feature 'User can log out' do

  given(:user) { create :user }
  background { visit root_path }
  scenario 'Registered and authorized user try to sign out' do
    sign_in(user)
    click_on 'Sign out'
    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Unregistered user have link to Sign_in' do
    expect(page).to have_link 'Sign in'
  end
end
