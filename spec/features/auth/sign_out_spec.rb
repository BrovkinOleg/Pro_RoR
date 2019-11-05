require 'rails_helper'

feature 'User can log out' do

  given(:user) { create :user }

  scenario 'Registered and authorized user try to log out' do
    log_in(user)
    visit root_path
    click_on 'Log out'
    expect(page).to have_content 'Log out successfully.'
  end
end
