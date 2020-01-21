require 'rails_helper'

feature 'User as admin can see sidekiq web' do
  given(:user) { create(:user) }
  given(:admin) { create(:user, admin: true) }

  describe 'Authenticated user' do
    scenario 'is admin' do
      sign_in(admin)
      visit sidekiq_web_path
      expect(page).to have_content 'Dashboard'
    end

    scenario 'is not admin' do
      sign_in(user)
      expect do
        visit sidekiq_web_path
      end.to raise_error(ActionController::RoutingError)
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not see sidekiq web' do
      visit sidekiq_web_path
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
