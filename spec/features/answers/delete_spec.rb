require 'rails_helper'

feature 'Delete Answer' do

  given(:user) { create :user }
  given(:another_user) { create :user }
  given!(:question) { create :question, user: user }
  given!(:answer) { create :answer, question: question, user: user }

  describe 'Authenticated user', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'author can delete attached answer file' do
      within '.answers' do
        click_on 'Edit'
        attach_file 'Files', "#{Rails.root}/spec/rails_helper.rb"
        click_on 'Save'
        click_on 'Edit'

        expect(page).to have_link 'rails_helper.rb'
        click_on 'Remove file'

        expect(page).to_not have_link 'rails_helper.rb'
      end
    end

    scenario 'author delete his answer' do

      expect(page).to have_content answer.body

      click_on 'Delete'
      expect(page).to have_no_content answer.body
    end

    scenario 'another user can not delete answer' do

      expect(page).to have_no_button 'Delete'
    end
  end
end
