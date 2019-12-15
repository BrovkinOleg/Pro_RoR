require 'rails_helper'

feature 'User can give vote to question' do
  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given(:third_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    describe 'vote' do
      background do
        sign_in(second_user)
        visit questions_path
      end

      scenario 'Two users press Like button' do
        click_on 'Like'

        expect(page).to have_content 'Total votes:1'
        using_session :new_session do
          sign_in(third_user)
          visit questions_path
          click_on 'Like'

          expect(page).to have_content 'Total votes:2'
        end
      end

      scenario 'First user press Dislike and second user press Like' do
        click_on 'Dislike'

        expect(page).to have_content 'Total votes:-1'
        using_session :new_session do
          sign_in third_user
          visit questions_path
          click_on 'Like'

          expect(page).to have_content 'Total votes:0'
        end
      end

      scenario 'First user press Dislike and second user press Dislike' do
        click_on 'Dislike'

        expect(page).to have_content 'Total votes:-1'
        using_session :new_session do
          sign_in(third_user)
          visit questions_path
          click_on 'Dislike'

          expect(page).to have_content 'Total votes:-2'
        end
      end

      scenario 'can give only one vote' do
        click_on 'Like'

        expect(page).to have_content 'Total votes:1'
        click_on 'Like'

        expect(page).to have_content 'Total votes:1'
      end
    end

    scenario 'Author question cannot vote' do
      sign_in user
      visit questions_path

      expect(page).to_not have_selector(:button, 'Like')
      expect(page).to_not have_selector(:button, 'Dislike')
    end

    describe 'Unauthenticated user' do
      scenario 'can not vote' do
        visit questions_path

        expect(page).to_not have_selector(:button, 'Like')
        expect(page).to_not have_selector(:button, 'Dislike')
      end
    end
  end
end
