Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  root 'static_pages#home'
  get 'static_pages/help' => "static_pages#help", as: :help
  get 'static_pages/about' => "static_pages#about", as: :about
  get 'static_pages/contact' => "static_pages#contact", as: :contact

  get 'signup' => "users#new", as: :signup

  get 'login' => "sessions#new" , as: :sessions_new
  post 'login' => "sessions#create", as: :login
  delete 'logout' => "sessions#destroy", as: :logout

  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
