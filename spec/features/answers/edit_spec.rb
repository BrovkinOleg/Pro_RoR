require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes as an author of answer
  I'd like to be able to edit my answer
  } do

  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:link) { create(:link, linkable: answer) }

  describe 'Authenticated user author', js: true do
    background do
      sign_in(answer.user)
      visit question_path(answer.question)
      click_on 'Edit'
    end

    scenario 'edits his answer' do
      within '.answers' do
        expect(page).to have_content answer.body
        fill_in 'Body_Edit', with: 'edited answer'
        click_on 'Save'

        expect(page).to have_no_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to have_no_selector('textarea')
      end
    end

    scenario 'edits his answer with errors' do
      within '.answers' do
        fill_in 'Body_Edit', with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'can add link for answer' do
      within '.answers' do
        fill_in 'Body_Edit', with: 'edited answer'
        #click_on 'add link'
        fill_in 'Link name', with: link.name
        fill_in 'Url', with: link.url
        click_on 'Save'

        expect(page).to have_link link.name, href: link.url
      end
    end

    scenario 'can delete link for answer' do
      within '.answers' do
        save_and_open_page
        #page.all('delete link')[1].click
        click_on 'delete link'
        click_on 'Save'

        expect(page).to have_no_link link.name, href: link.url
      end
    end

    describe 'edits his answer with', js: true do
      background do
        within '.answers' do
          fill_in 'Body_Edit', with: 'edited answer'
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'
          click_on 'Edit'
        end
      end

      scenario 'attached files' do
        within '.answers' do
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end
  end

  describe 'Authenticated not author' do
    background do
      sign_in(second_user)
      visit question_path(answer.question)
    end

    scenario 'tries to edit not his answer', js: true do
      expect(page).to have_no_link('Edit')
    end

    scenario 'tries to delete attached file from answer' do
      expect(page).to have_no_link('delete file')
    end
  end

  describe 'Unauthenticated user' do
    background do
      visit questions_path(question)
    end

    scenario 'can not edit answer' do
      visit questions_path(question)

      expect(page).to have_no_link 'Edit'
    end

    scenario 'can not delete attached file' do
      expect(page).to have_no_link 'delete file'
    end
  end
end
