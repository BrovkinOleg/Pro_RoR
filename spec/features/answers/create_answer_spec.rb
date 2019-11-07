require 'rails_helper'

feature 'Create answer', %q{
  User who ask question can give answer on the question
} do

  given(:user) { create :user }
  given!(:question) { create :question, user: user }

  scenario 'Authenticated user tries create answer with valid attr'  do
    sign_in(user)
    visit root_path
    click_on question.title
    fill_in 'Add your answer', with: 'test answer'
    click_on 'Create'

    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content 'test answer'
    expect(current_path).to eq question_path(question)
  end

  scenario 'Authenticated user tries create answer with not-valid attr'  do
    sign_in(user)
    visit root_path
    click_on question.title
    fill_in 'Add your answer', with: ''
    click_on 'Create'

    expect(page).to have_content 'Answer field can not be blank.'
    expect(current_path).to eq question_path(question)
  end

  scenario 'Non-authenticated user tries to create answer' do
    visit root_path
    click_on question.title

    expect(page).to have_no_content 'Create answer'
  end
end