Rails.application.routes.draw do
  use_doorkeeper

  root to: 'home#index'

  namespace :api, format: :json do
    resources :prisoners, format: :json do
      resources :aliases
    end
  end

  devise_for :users
end
