Rails.application.routes.draw do
  root 'static_pages#home'
  get 'static_pages/help' => "static_pages#help", as: :help
  get 'static_pages/about' => "static_pages#about", as: :about
  get 'static_pages/contact' => "static_pages#contact", as: :contact

  get 'signup' => "users#new", as: :signup

  get 'login' => "sessions#new" , as: :sessions_new
  post 'login' => "sessions#create", as: :login
  delete 'logout' => "sessions#destroy", as: :logout

  resources :users
  resources :account_activations, only: [:edit]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
