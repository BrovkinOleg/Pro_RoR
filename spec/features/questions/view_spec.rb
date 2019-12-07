require 'rails_helper'

feature 'View question', js: true do

  given!(:user) { create :user }
  given!(:question) { create :question, user: user }
  given!(:answers) { create_list(:answer, 2, body: 'text', question: question, user: user) }

  scenario 'user can view question and answers' do
    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end

  describe 'User', js: true do
    given!(:second_link) { create(:link, :gist, linkable: question.answers.first) }
    given!(:link) { create(:link, :gist, linkable: question) }

    scenario 'can see question gist content on page' do
      visit question_path(question)
      expect(page).to have_content 'question_5'
    end

    scenario 'can see answer gist content on page' do
      visit question_path(question)
      expect(page).to have_content 'question_5'
    end
  end
end
