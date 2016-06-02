class HomeController < ApplicationController
  def index
    @applications = Doorkeeper::Application.order(name: :asc)
  end
end
