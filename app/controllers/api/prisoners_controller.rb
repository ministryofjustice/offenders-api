module Api
  class PrisonersController < Api::ApplicationController
    before_action :set_prisoner, only: [:show, :update, :destroy]

    def index
      @prisoners = Prisoner.all

      render json: @prisoners
    end

    def show
      render json: @prisoner
    end

    def search
      if params[:noms_id].blank? || params[:date_of_birth].blank?
        render json: { error: 'NOMS ID or date of birth not present' }, status: 400
      else
        output = {
          found: true,
          offender: {
            id: 1234
          }
        }

        render json: output, status: 200
      end
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
end
