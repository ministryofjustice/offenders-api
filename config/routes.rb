Rails.application.routes.draw do
  use_doorkeeper

  root to: 'home#index'

  resources :prisoners, format: :json do
    resources :aliases
  end
end
