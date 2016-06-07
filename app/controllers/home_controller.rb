class HomeController < ApplicationController
  before_action :doorkeeper_authorize!, except: [:index]

  def index
    @applications = Doorkeeper::Application.order(name: :asc)
  end
end
