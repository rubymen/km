Km::Application.routes.draw do
  devise_for :users

  resources :documents
  resources :tags
  resources :users
end
