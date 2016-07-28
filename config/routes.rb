Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users

  get 'ping', to: 'heartbeat#ping', format: :json
  get 'healthcheck', to: 'heartbeat#healthcheck',  as: 'healthcheck', format: :json

  authenticate :user do
    root to: 'services#index'
    resources :services
    resources :imports, only: [:index, :show, :new, :create]
  end

  namespace :api, format: :json do
    scope module: :v1, constraints: ApiConstraint.new(version: 1) do
      resources :prisoners, format: :json, except: [:new, :edit, :destroy] do
        get :search, on: :collection
        resources :aliases, except: [:new, :edit]
      end
    end
  end
end
