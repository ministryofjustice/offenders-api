Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users

  get 'ping', to: 'heartbeat#ping', format: :json
  get 'healthcheck', to: 'heartbeat#healthcheck',  as: 'healthcheck', format: :json

  resources :apidocs, only: [:index]
  mount SwaggerEngine::Engine, at: "/api-docs"

  authenticate :user do
    constraints RoleConstraint.new(:admin) do
      get '/', to: redirect('services#index')
    end

    root to: 'imports#new'

    resources :services
    resources :imports, only: [:new, :create]
  end

  namespace :api, format: :json do
    scope module: :v1, constraints: ApiConstraint.new(version: 1) do
      resources :offenders, format: :json, except: [:new, :create, :edit, :update, :destroy] do
        get :search, on: :collection
      end
      resources :identities, format: :json, except: [:new, :edit] do
        get :search, on: :collection
        patch :make_current, on: :member
        patch :activate, on: :member
      end
    end
  end
end
