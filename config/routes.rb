Km::Application.routes.draw do
  devise_for :users
  root to: 'documents#index'

  resources :documents do
    get 'autocomplete', on: :collection
    get 'change_version', on: :member
    get :state, on: :member
    resources :comments, on: :member, except: [:show, :edit, :update] do
      resources :comments, on: :member, only: [:new, :create]
    end
  end
  resources :tags
  resources :users do
    get 'autocomplete', on: :collection
  end
end
