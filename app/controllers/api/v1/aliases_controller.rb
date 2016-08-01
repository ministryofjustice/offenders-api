module Api
  module V1
    class AliasesController < Api::ApplicationController
      before_action :set_prisoner
      before_action :set_alias, only: [:show, :update, :destroy]

      swagger_controller :aliases, "Prisoner aliases"

      swagger_api :index do
        summary "Fetches all prisoners aliases"
        notes "This lists all the known active prisoner aliases"
        param :path, :prisoner_id, :integer, :required, "Prisoner Id"
        response :unauthorized
        response :not_acceptable, "The request you made is not acceptable"
      end

      def index
        @aliases = @prisoner.aliases

        render json: @aliases
      end

      def show
        render json: @alias
      end

      def create
      end

      def update
      end

      def destroy
      end

      private

      def set_prisoner
        @prisoner = Prisoner.find(params[:prisoner_id])
      end

      def set_alias
        @alias = @prisoner.aliases.find(params[:id])
      end
    end
  end
end
