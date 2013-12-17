Km::Application.routes.draw do
  devise_for :users
  resources :users
end
