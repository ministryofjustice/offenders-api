module Api
  module V1
    class OffendersController < Api::ApplicationController
      include Swagger::Blocks
      include OffenderResource

      before_action :doorkeeper_authorize!, only: [:index, :search, :show]
      before_action -> { doorkeeper_authorize! :write }, only: [:merge]

      after_action only: [:index, :search] { set_pagination_headers(:offenders) }

      def index
        @offenders = Offender.includes(:current_identity).active.page(params[:page]).per(params[:per_page])
        @offenders = @offenders.updated_after(updated_after) if updated_after

        render json: @offenders
      end

      def search
        @offenders = Offender.includes(:current_identity).active.search(search_params)
        @offenders = @offenders.page(params[:page]).per(params[:per_page])

        render json: @offenders
      end

      def show
        offender = Offender.find(params[:id])

        if offender.merged?
          offender_to_redirect_to = Offender.find(offender.merged_to_id)
          render json: offender_to_redirect_to, status: 302
        else
          render json: offender
        end
      end

      def merge
        offender_merge_from = Offender.find(merge_params[:offender_id])
        offender_merge_to = Offender.find(params[:id])

        MergeOffenders.call(offender_merge_from, offender_merge_to, merge_params)
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

      def merge_params
        params.permit(
          :offender_id, :current_identity_id, :identity_ids
        )
      end
    end
  end
end
