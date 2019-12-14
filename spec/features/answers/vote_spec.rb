require 'rails_helper'

feature 'User can give vote to answer' do
  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given(:third_user) { create(:user) }

  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated users', js: true do
    describe 'try to vote' do
      background do
        sign_in(second_user)
        visit question_path(question)
      end

      scenario 'Two users press Like button' do
        click_on 'Like'

        expect(page).to have_content 'Total votes:1'
        click_on 'Sign out'

        sign_in(third_user)
        visit question_path(question)
        click_on 'Like'

        expect(page).to have_content 'Total votes:2'
      end

      scenario 'First user press Dislike and second user press Like' do
        click_on 'Dislike'

        expect(page).to have_content 'Total votes:-1'
        click_on 'Sign out'

        sign_in(third_user)
        visit question_path(question)
        click_on 'Like'

        expect(page).to have_content 'Total votes:0'
      end

      scenario 'First user press Dislike and second user press Dislike' do
        click_on 'Dislike'

        expect(page).to have_content 'Total votes:-1'
        click_on 'Sign out'

        sign_in(third_user)
        visit question_path(question)
        click_on 'Dislike'

        expect(page).to have_content 'Total votes:-2'
      end

      scenario 'can give only one vote' do
        click_on 'Like'

        expect(page).to have_content 'Total votes:1'
        click_on 'Like'

        expect(page).to have_content 'Total votes:1'
      end
    end

    scenario 'Author question cannot vote' do
      sign_in(user)
      visit question_path(question)

      expect(page).to have_no_selector(:button, 'Like')
      expect(page).to have_no_selector(:button, 'Dislike')
    end

    describe 'Unauthenticated user' do
      scenario 'can not vote' do
        visit question_path(question)

        expect(page).to have_no_selector(:button, 'Like')
        expect(page).to have_no_selector(:button, 'Dislike')
      end
    end
  end
end
