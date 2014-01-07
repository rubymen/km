Km::Application.routes.draw do
  devise_for :users

  resources :attachments
  resources :documents
  resources :tags
  resources :users
end
