module Api
  module V1
    class PrisonersController < Api::ApplicationController
      before_action :set_prisoner, only: [:show, :update, :destroy]

      def index
        @prisoners = Prisoner.basic_search(params[:query])

        render json: @prisoners
      end

      def show
        render json: @prisoner
      end

      def create
        @prisoner = Prisoner.new(prisoner_params)

        if @prisoner.save
          render json: true, status: :created
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

      def destroy
        @prisoner.destroy

        render json: true, status: :ok
      end

      private

      def prisoner_params
        params.require(:prisoner).permit(
          :noms_id,
          :offender_id,
          :given_name,
          :middle_names,
          :surname,
          :title,
          :suffix,
          :date_of_birth,
          :gender,
          :pnc_number,
          :nationality,
          :ethnicity,
          :requires_interpreter,
          :sexual_orientation,
          languages: []
        )
      end

      def set_prisoner
        @prisoner = Prisoner.find(params[:id])
      end
    end
  end
end
