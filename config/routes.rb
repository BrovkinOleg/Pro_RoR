require 'sidekiq/web'

Rails.application.routes.draw do

  # authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  # end

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

  get '/search', to: 'search#search'

  resources :questions, concerns: :votable do
    resources :comments, only: :create, defaults: { commentable: 'questions' }
    resources :answers, concerns: :votable, shallow: true, except: [:index] do
      resources :comments, only: :create, defaults: { commentable: 'answers' }
      patch "best_answer", on: :member, as: :best
    end
    resources :subscribers, only: %i[create destroy], shallow: true
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end
      resources :questions, except: %i[new edit] do
        resources :answers, shallow: true, except: %i[new edit]
      end
    end
  end

  resources :attachments, only: :destroy
  resources :profits, only: :index
  root to: 'questions#index'

end
