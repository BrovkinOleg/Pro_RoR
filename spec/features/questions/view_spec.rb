require 'rails_helper'

feature 'View question', js: true do

  given(:user) { create :user }
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
end
