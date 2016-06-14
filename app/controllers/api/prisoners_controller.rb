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
        prisoner = Prisoner.where(noms_id: params[:noms_id], date_of_birth: params[:date_of_birth]).first

        if prisoner
          output = {
            found: true,
            offender: {
              id: prisoner.offender_id
            }
          }

          render json: output, status: 200
        else
          render json: { found: false }, status: 404
        end
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
