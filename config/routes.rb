Km::Application.routes.draw do
  devise_for :users
  root to: 'documents#index'

  resources :attachments
  resources :documents do
    resources :comments, on: :member, except: [:show, :edit, :update] do
      resources :comments, on: :member, only: [:new, :create]
    end
  end
  resources :tags
  resources :users
end
