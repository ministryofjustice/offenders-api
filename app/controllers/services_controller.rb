class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :update, :destroy]

  def index
    @applications = Doorkeeper::Application.order(name: :asc)
  end

  def show
  end

  def new
  end

  def edit
  end

  def create

  end

  def update

  end

  def destroy

  end

  private

  def set_service
    @application = Doorkeeper::Application.find(params[:id])
  end
end
