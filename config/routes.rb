Rails.application.routes.draw do
  get 'users/new', as: :signup

  root 'static_pages#home'
  
  get 'static_pages/help', as: :help
  get 'static_pages/about', as: :about
  get 'static_pages/contact', as: :contact
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
