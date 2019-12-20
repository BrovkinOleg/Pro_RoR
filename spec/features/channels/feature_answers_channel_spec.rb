require 'rails_helper'

feature 'User can see in real time appearance of new answers' do
  given(:user) { create :user }
  given(:question) { create(:question, user: user ) }

  describe 'new answer', js: true do
    background do
      Capybara.using_session('user') do
        sign_in(question.user)
        visit question_path(question)
        expect(page).to have_no_content 'my awesome answer'
      end

      Capybara.using_session('guest') do
        visit question_path(question)
        expect(page).to have_no_content 'my awesome answer'
      end
    end

    scenario 'appears on another user page' do
      Capybara.using_session('user') do
        fill_in 'Add your answer', with: 'test answer'
        click_on 'Create answer'

        within '.answers' do
          expect(page).to have_content 'test answer'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_selector('div', id: "answer_#{question.answers.first.id}")
        expect(page).to have_content 'test answer'
      end
    end

    scenario 'with errors does not appear on another user page' do
      Capybara.using_session('user') do
        click_on 'Create answer'

        expect(page).to have_content "Body can't be blank"
      end

      Capybara.using_session('guest') do
        expect(page).to have_no_css '.answers'
      end
    end
  end
end
