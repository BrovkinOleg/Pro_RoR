require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
  " do
  given!(:user) { create(:user) }
  given(:new_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:link) { create(:link, linkable: question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit root_path
      click_on 'Edit question'
    end

    scenario 'edits his own question', js: true do
      expect(page).to have_content 'MyString'
      expect(page).to have_content 'MyText'
      fill_in 'Edit title', with: 'edited title'
      fill_in 'Edit body', with: 'edited body'
      click_on 'Save'
      expect(page).to have_link 'edited title'
      expect(page).to have_no_content "edited body"
    end

    scenario 'edits his question with errors' do
      fill_in 'Edit title', with: ''
      fill_in 'Edit body', with: ''
      click_on 'Save'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'adds link to the question' do
      fill_in 'Edit title', with: 'edited title'
      fill_in 'Edit body', with: 'edited body'
      fill_in 'Link name', with: link.name
      fill_in 'Url', with: link.url
      click_on 'Save'
      visit question_path(question)

      expect(page).to have_link link.name, href: link.url
    end

    scenario 'can delete link from the question' do
      expect(page).to have_link link.name

      click_on 'delete link'
      click_on 'Save'
      visit question_path(question)

      expect(page).to have_no_link link.name
    end

    describe 'Author of question', js: true do
      scenario 'edits question fields and add files' do
        fill_in 'Edit title', with: 'edited title'
        fill_in 'Edit body', with: 'edited body'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_content 'edited title'

        visit question_path(question)

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  describe 'Author of question', js: true do
    background do
      sign_in(question.user)
      question.files.attach(create_file_blob)
      visit question_path(question)
    end

    scenario 'can delete attached file' do
      expect(page).to have_link 'Remove file'
      expect(page).to have_link 'file.jpg'

      click_on 'Remove file'

      expect(page).to have_no_link 'file.jpg'
      expect(page).to have_no_link 'Remove file'
    end
  end

  describe 'Authenticated not author', js: true do
    background do
      sign_in(new_user)
    end

    scenario 'tries to edit not his question' do
      visit root_path

      expect(page).to have_no_link('Edit question')
    end

    scenario 'tries to delete attached file from question' do
      visit question_path(question)

      expect(page).to have_no_link('Remove file')
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario 'can not edit question' do
      visit root_path

      expect(page).to have_no_link 'Edit question'
    end

    scenario 'can not delete attached file' do
      visit question_path(question)

      expect(page).to have_no_link 'Remove file'
    end
  end
end
