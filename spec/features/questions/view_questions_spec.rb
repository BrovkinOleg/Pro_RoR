require 'rails_helper'

feature 'View questions' do

  given(:user) { create :user }
  given!(:question) { create :question, user: user }
  given!(:answer) { create :answer, question: question, user:user }

  scenario 'user can view questions' do
    sign_in(user)
    visit root_path
    click_on question.title

    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'user can view answers' do
    visit root_path
    click_on question.title

    expect(page).to have_content answer.body
  end
end
