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
      end

      # swagger_api :search do
      #   summary "Searches prisoners"
      #   notes "This searches all the active prisoners"
      #   param :query, :query, :string, :required, "Search query"
      #   response :unauthorized
      #   response :not_acceptable, "The request you made is not acceptable"
      # end

      swagger_api :show do
        summary "Show a prisoners record"
        notes "This shows a prisoner record"
        param :path, :id, :integer, :required, "Prisoner Id"
        response :unauthorized
        response :not_acceptable, "The request you made is not acceptable"
      end

      # swagger_api :update do
      #   summary "Update prisoners record"
      #   notes "This updates a prisoner record"
      #   param :path, :id, :integer, :required, "Prisoner Id"
      #   param :form, "prisoner[noms_id]", :string, :optional, "NOMS Id"
      #   response :unauthorized
      #   response :not_acceptable, "The request you made is not acceptable"
      # end
      #
      # swagger_api :create do
      #   summary "Create a new prisoner record"
      #   notes "This creates a new prisoner record"
      #   param :form, "prisoner[noms_id]", :string, :required, "NOMS Id"
      #   param :form, "prisoner[given_name]", :string, :required, "First or given name"
      #   param :form, "prisoner[surname]", :string, :required, "Surname"
      #   param :form, "prisoner[date_of_birth]", :string, :required, "DOB"
      #   param :form, "prisoner[gender]", :string, :required, "Gender"
      #   response :unauthorized
      #   response :not_acceptable, "The request you made is not acceptable"
      # end

      def index
        @prisoners = Prisoner.all

        render json: @prisoners
      end

      # def search
      #   @prisoners = Prisoner.search(params[:query])
      #
      #   render json: @prisoners
      # end

      def show
        render json: @prisoner
      end

      # def create
      #   @prisoner = Prisoner.new(prisoner_params)
      #
      #   if @prisoner.save
      #     render json: @prisoner.id, status: :created
      #   else
      #     render json: { error: @prisoner.errors }, status: 422
      #   end
      # end
      #
      # def update
      #   if @prisoner.update(prisoner_params)
      #     render json: true, status: 200
      #   else
      #     render json: { error: @prisoner.errors }, status: 422
      #   end
      # end

      private

      # def prisoner_params
      #   params.require(:prisoner).permit(
      #     :noms_id,
      #     :given_name,
      #     :middle_names,
      #     :surname,
      #     :title,
      #     :suffix,
      #     :date_of_birth,
      #     :gender,
      #     :pnc_number,
      #     :nationality_code,
      #     :cro_number
      #   )
      # end

      def set_prisoner
        @prisoner = Prisoner.find(params[:id])
      end
    end
  end
end
