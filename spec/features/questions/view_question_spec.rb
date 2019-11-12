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
    expect(page).to have_content answer_01.body
    expect(page).to have_content answer_02.body
    expect(page).to have_content answer_03.body
  end
end
