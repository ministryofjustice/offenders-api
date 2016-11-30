module Api
  module V1
    class IdentitiesController < Api::ApplicationController
      include Swagger::Blocks
      include IdentityResource

      def index
        @identities = Identity.order(:surname, :given_name, :middle_names).page(params[:page]).per(params[:per_page])

        render json: @identities
      end

      def search
        @identities = Identity.search(search_params).page(params[:page]).per(params[:per_page])

        render json: @identities
      end

      def show
        @identity = Identity.find(params[:id])

        render json: @identity
      end

      def create
        if offender.valid?
          create_identity
        else
          render json: { error: @offender.errors }, status: 422
        end
      end

      def update
        @identity = Identity.find(params[:id])

        if @identity.update(identity_params) && @identity.offender.update(offender_params)
          render json: { success: true }, status: 200
        else
          render json: { error: identity_or_offender_errors }, status: 422
        end
      end

      private

      def offender
        @offender ||=
          if identity_params[:offender_id]
            Offender.find(identity_params[:offender_id])
          else
            Offender.create(offender_params)
          end
      end

      def create_identity
        @identity = offender.identities.build(identity_params)
        if @identity.save
          update_current_identity_of_offender
          render json: { id: @identity.id, offender_id: offender.id }, status: :created
        else
          render json: { error: @identity.errors }, status: 422
        end
      end

      def update_current_identity_of_offender
        offender.update_attribute(:current_identity, @identity) unless identity_params[:offender_id]
      end

      def identity_or_offender_errors
        return @identity.errors unless @identity.valid?
        return @identity.offender.errors unless @identity.offender.valid?
      end

      def offender_params
        params.require(:identity).permit(
          :noms_id,
          :nationality_code,
          :establishment_code
        )
      end

      def identity_params
        params.require(:identity).permit(
          :offender_id,
          :nomis_offender_id,
          :given_name,
          :middle_names,
          :surname,
          :title,
          :suffix,
          :date_of_birth,
          :gender,
          :pnc_number,
          :cro_number
        )
      end

      def search_params
        params.permit(
          :offender_id,
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
    end
  end
end
