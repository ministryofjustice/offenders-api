module Api
  module V1
    class OffendersController < Api::ApplicationController
      include Swagger::Blocks
      include OffenderResource

      def index
        @offenders = Offender.page(params[:page]).per(params[:per_page])
        @offenders = @offenders.updated_after(updated_after) if updated_after

        render json: @offenders
      end

      def search
        @offenders = Offender.search(search_params).page(params[:page]).per(params[:per_page])

        render json: @offenders
      end

      def show
        @offender = Offender.find(params[:id])

        render json: @offender
      end

      private

      def search_params
        params.permit(:noms_id)
      end

      def updated_after
        @_updated_after ||= Time.parse(params[:updated_after])
      rescue ArgumentError, TypeError
        nil
      end
    end
  end
end
