Rails.application.routes.draw do
  root to: 'users#index'

  resources :users
  resources :questions, except: [:show, :new, :index]
  resource :session, only: [:new, :create, :destroy]
  resources :hashtag, only: [:show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
