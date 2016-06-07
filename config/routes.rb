Rails.application.routes.draw do
  use_doorkeeper

  root to: 'services#index'

  resources :services

  namespace :api, format: :json do
    resources :prisoners, format: :json do
      resources :aliases
    end
  end

  devise_for :users
end
