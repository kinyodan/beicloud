Rails.application.routes.draw do
  get 'git_control/index'
  resources :onboardings
  post "clone_repo", to: "git_control#clone_repo"
  get 'home/index'
  resources :apps
  get 'app/index'
  get 'app/show'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

end
