Rails.application.routes.draw do
  root to: 'users#index'

  resources :users, except: [:destroy]
  resources :questions
  resources :sessions, only: [:new, :create, :destroy]

  get 'sign_up' => 'users#new'
  get 'log_out' => 'sessions#destroy'
  get 'log_in' => 'sessions#new'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
