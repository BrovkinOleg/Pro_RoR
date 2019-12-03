Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :questions do
    resources :answers, except: [:index] do
      patch "best_answer", on: :member, as: :best
    end
  end
  resources :attachments, only: :destroy
  resources :links, only: :destroy

  resources :users do
    resources :profits, only: :index
  end

  root to: 'questions#index'

end
