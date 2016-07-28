module Api
  module V1
    class PrisonersController < Api::ApplicationController
      before_action :set_prisoner, only: [:show, :update, :destroy]

      swagger_controller :prisoners, "Prisoner core records"

      swagger_api :index do
        summary "Fetches all prisoners"
        notes "This lists all the active prisoners"
        response :unauthorized
        response :not_acceptable, "The request you made is not acceptable"
        response :requested_range_not_satisfiable
      end

      def index
        @prisoners = Prisoner.all

        render json: @prisoners
      end

      def search
        @prisoners = Prisoner.search(params[:query])

        render json: @prisoners
      end

      def show
        render json: @prisoner
      end

      def create
        @prisoner = Prisoner.new(prisoner_params)

        if @prisoner.save
          render json: @prisoner.id, status: :created
        else
          render json: { error: @prisoner.errors }, status: 422
        end
      end

      def update
        if @prisoner.update(prisoner_params)
          render json: true, status: 200
        else
          render json: { error: @prisoner.errors }, status: 422
        end
      end

      private

      def prisoner_params
        params.require(:prisoner).permit(
          :noms_id,
          :given_name,
          :middle_names,
          :surname,
          :title,
          :suffix,
          :date_of_birth,
          :gender,
          :pnc_number,
          :nationality,
          :second_nationality,
          :ethnicity_code,
          :sexual_orientation,
          :cro_number
        )
      end

      def set_prisoner
        @prisoner = Prisoner.find(params[:id])
      end
    end
  end
end
