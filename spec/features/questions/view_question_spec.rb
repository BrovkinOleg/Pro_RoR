require 'rails_helper'

feature 'View question' do

  given(:user) { create :user }
  given!(:question) { create :question, user: user }
  given!(:answer) { create :answer, question: question, user:user }

  scenario 'user can view question' do
    sign_in(user)
    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'user can view answers' do
    visit question_path(question)
    expect(page).to have_content answer.body
  end
end
