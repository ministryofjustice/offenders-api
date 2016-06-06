class PrisonersController < ApplicationController
  before_action :doorkeeper_authorize!
  before_action :set_prisoner, only: [:show, :update, :destroy]

  def index
    @prisoners = Prisoner.all

    render json: @prisoners
  end

  def show
    render json: @prisoner
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

  def set_prisoner
    @prisoner = Prisoner.find(params[:id])
  end
end
