require 'rails_helper'

feature 'Delete Answer' do

  given(:user) { create :user }
  given(:another_user) { create :user }
  given(:question) { create :question, user: user }
  given!(:answer) { create :answer, question: question, user: user }

  scenario 'author delete his answer' do
    sign_in(user)
    visit question_path(question)
    expect(page).to have_content 'MyText'
    click_on 'Delete answer'
    expect(page).to have_content 'Answer successfully deleted.'
  end

  scenario 'another user can not delete answer' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_no_button 'Delete answer'
  end
end
