module Api
  module V1
    class IdentitiesController < Api::ApplicationController
      include Swagger::Blocks
      include IdentityResource

      before_action :doorkeeper_authorize!, only: [:index, :search, :inactive, :blank_noms_offender_id, :show]
      before_action -> { doorkeeper_authorize! :write }, only: [:create, :update, :destroy, :activate, :make_current]

      after_action only: [:index, :search, :inactive, :blank_noms_offender_id] do
        set_pagination_headers(:identities) unless search_params[:count]
      end

      def index
        @identities = Identity.active.order(:surname, :given_name_1, :given_name_2)
        @identities = @identities.page(params[:page]).per(params[:per_page])

        render json: @identities
      end

      def search
        @identities = Identity.active.search(search_params)
        @identities = @identities.page(params[:page]).per(params[:per_page]) unless search_params[:count]

        render json: @identities
      end

      def inactive
        @identities = Identity.inactive.order(:surname, :given_name_1, :given_name_2)
        @identities = @identities.page(params[:page]).per(params[:per_page])

        render json: @identities
      end

      def blank_noms_offender_id
        @identities = Identity.blank_noms_offender_id.order(:surname, :given_name_1, :given_name_2)
        @identities = @identities.page(params[:page]).per(params[:per_page])

        render json: @identities
      end

      def show
        render json: identity
      end

      def create
        new_identity = nil

        ActiveRecord::Base.transaction do
          offender = find_or_create_offender
          new_identity = offender.identities.create!(identity_params)
          offender.update!(current_identity: new_identity) unless identity_params[:offender_id]
        end

        render json: new_identity, status: :created
      end

      def update
        ActiveRecord::Base.transaction do
          identity.update!(identity_params)
          identity.offender.update!(offender_params)
        end

        render json: identity
      end

      def destroy
        identity.soft_delete!
      end

      def activate
        identity.make_active!
      end

      def make_current
        identity.offender.update!(current_identity: identity)
      end

      private

      def identity
        Identity.find(params[:id])
      end

      def find_or_create_offender
        if identity_params[:offender_id]
          Offender.find(identity_params[:offender_id])
        else
          Offender.create!(offender_params)
        end
      end

      def offender_params
        params.require(:identity).permit(:noms_id, :nationality_code, :establishment_code)
      end

      def identity_params
        params.require(:identity).permit(
          :offender_id, :noms_offender_id, :pnc_number, :cro_number, :ethnicity_code,
          :title, :given_name_1, :given_name_2, :given_name_3, :surname, :suffix, :date_of_birth, :gender
        )
      end

      def search_params
        params.permit(
          :offender_id, :noms_id, :pnc_number, :cro_number, :establishment_code, :ethnicity_code,
          :given_name_1, :given_name_2, :given_name_3, :surname, :gender,
          :date_of_birth, :date_of_birth_from, :date_of_birth_to,
          :name_switch, :exact_surname, :name_variation, :soundex,
          :count
        )
      end
    end
  end
end
