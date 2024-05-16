# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations', omniauth_callbacks: 'callbacks' }

  # devise_for :users, :controllers => { :sessions => "sessions" }

  devise_scope :user do
    post 'git_login', to: 'devise/sessions#new'
  end

  devise_scope :user do
    get 'git_sign_up', to: 'devise/registrations#new'
  end
  get 'logout', to: 'sessions#delete'
  get 'login', to: 'sessions#create'
  # get '/auth/:provider/callback', to: 'sessions#auth'
  # get 'auth', to: "sessions#auth"
  resources :beiapps
  resources :beispaces
  get 'git_control/index'
  resources :onboardings
  post 'clone_repo', to: 'git_control#clone_repo'
  get 'home/index'
  resources :apps
  get 'app/index'
  get 'app/show'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'home#index'
end
