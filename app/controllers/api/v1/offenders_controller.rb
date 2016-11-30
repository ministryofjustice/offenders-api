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

      # def create
      #   @offender = Offender.new(offender_params.except(:identities))
      #
      #   if @offender.save
      #     @offender.update_identities(offender_params[:identities])
      #     render json: { id: @offender.id }, status: :created
      #   else
      #     render json: { error: @offender.errors }, status: 422
      #   end
      # end
      #
      # def update
      #   @offender = Offender.find(params[:id])
      #
      #   if @offender.update(offender_params.except(:identities))
      #     @offender.update_identities(offender_params[:identities])
      #     render json: { success: true }, status: 200
      #   else
      #     render json: { error: @offender.errors }, status: 422
      #   end
      # end

      private

      # def offender_params
      #   params.require(:offender).permit(
      #     :noms_id,
      #     :given_name,
      #     :middle_names,
      #     :surname,
      #     :title,
      #     :suffix,
      #     :date_of_birth,
      #     :gender,
      #     :nationality_code,
      #     :pnc_number,
      #     :cro_number,
      #     :establishment_code,
      #     identities: [:given_name, :middle_names, :surname, :title, :suffix, :gender, :date_of_birth]
      #   )
      # end

      def search_params
        params.permit(
          :noms_id,
          :given_name,
          :middle_names,
          :surname,
          :date_of_birth,
          :gender,
          :pnc_number,
          :cro_number,
          :establishment_code
        )
      end

      def updated_after
        @_updated_after ||= Time.parse(params[:updated_after])
      rescue ArgumentError, TypeError
        nil
      end
    end
  end
end
