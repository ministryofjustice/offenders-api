Rails.application.routes.draw do
  use_doorkeeper

  resources :prisoners, format: :json
end
