require 'rails_helper'

feature 'View question' do

  given(:user) { create :user }
  given!(:question) { create :question, user: user }
  given!(:answer_01) { create :answer, question: question, user:user }
  given!(:answer_02) { create :answer, question: question, user:user }
  given!(:answer_03) { create :answer, question: question, user:user }

  scenario 'user can view question and answers' do
    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body

    expect(page).to have_content "text_1"
    expect(page).to have_content "text_2"
    expect(page).to have_content "text_3"
  end
end
