require 'rails_helper'

feature 'Delete question', js: true do

  given(:user) { create :user }
  given(:another_user) { create :user }
  given!(:question) { create :question, user: user}

  scenario 'authorized user can delete his question' do
    sign_in(user)
    visit question_path(question)
    expect(page).to have_content question.title
    click_on 'Delete question'

    expect(page).to have_content 'You question successfully deleted.'
    expect(page).to have_no_content question.title
    expect(current_path).to eq questions_path
  end

  scenario 'authorized user can not delete not his question' do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to have_no_link 'Delete question'
  end

  scenario 'non-authorized user can not delete any question' do
    visit question_path(question)

    expect(page).to have_no_link 'Delete question'
  end
end
