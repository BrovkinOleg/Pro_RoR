Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  concern :votable do
    member do
      post :vote_up, :vote_down
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, concerns: :votable, shallow: true, except: [:index] do
      patch "best_answer", on: :member, as: :best
    end
  end

  resources :attachments, only: :destroy
  resources :profits, only: :index
  root to: 'questions#index'

end
