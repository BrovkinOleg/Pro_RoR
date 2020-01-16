Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  devise_scope :user do
    post '/fill_email' => 'oauth_callbacks#fill_email'
  end

  concern :votable do
    member do
      post :vote_up, :vote_down
    end
  end

  resources :questions, concerns: :votable do
    resources :comments, only: :create, defaults: { commentable: 'questions' }
    resources :answers, concerns: :votable, shallow: true, except: [:index] do
      resources :comments, only: :create, defaults: { commentable: 'answers' }
      patch "best_answer", on: :member, as: :best
    end
  end

  resources :attachments, only: :destroy
  resources :profits, only: :index
  root to: 'questions#index'

end
