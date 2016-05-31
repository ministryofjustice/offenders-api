class PrisonersController < ApplicationController
  before_action :set_prisoner, only: [:show, :update, :destroy]

  def index
    @prisoners = [
      { name: 'John Smith' }
    ]

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
    @prisoner = { name: 'John Smith' }
  end
end
