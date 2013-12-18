Km::Application.routes.draw do
  devise_for :users

  resources :documents
  resources :users
end
