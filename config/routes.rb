Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users

  authenticate :user do
    root to: 'services#index'
    resources :services
  end

  namespace :api, format: :json do
    resources :prisoners, format: :json do
      resources :aliases
    end
  end
end
