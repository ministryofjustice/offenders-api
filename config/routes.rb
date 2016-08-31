Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users

  get 'ping', to: 'heartbeat#ping', format: :json
  get 'healthcheck', to: 'heartbeat#healthcheck',  as: 'healthcheck', format: :json

  authenticate :user do
    constraints RoleConstraint.new(:admin) do
      get '/', to: redirect('services#index')
    end

    root to: 'imports#index'

    resources :services
    resources :imports, only: [:index, :new, :create]
    mount SwaggerEngine::Engine, at: "/api-docs"
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
