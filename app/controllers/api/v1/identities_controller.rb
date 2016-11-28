module Api
  module V1
    # rubocop:disable Metrics/ClassLength
    # rubocop:disable Metrics/BlockLength
    class IdentitiesController < Api::ApplicationController
      include Swagger::Blocks

      swagger_path '/identities' do
        operation :get do
          key :description, 'Returns a paginated list of identities'
          key :operationId, 'findIdentities'
          key :produces, ['application/json']
          key :tags, ['identity']
          parameter do
            key :name, :page
            key :in, :query
            key :description, 'Page to return'
            key :required, false
            key :type, :integer
            key :format, :int32
          end
          parameter do
            key :name, :per_page
            key :in, :query
            key :description, 'Per page number of results'
            key :required, false
            key :type, :integer
            key :format, :int32
          end
          parameter do
            key :name, :updated_after
            key :in, :query
            key :description, 'Identities updated after given timestamp'
            key :required, false
            key :type, :string
            key :format, 'date-time'
          end
          response 200 do
            key :description, 'A list of identities'
            schema do
              key :type, :array
              items do
                key :'$ref', :Identity
              end
            end
          end
          response :default do
            key :description, 'unexpected error'
            schema do
              key :'$ref', :ErrorModel
            end
          end
        end

        operation :post do
          key :description, 'Creates a new identity'
          key :operationId, 'addIdentity'
          key :produces, ['application/json']
          key :tags, ['identity']
          parameter do
            key :name, :identity
            key :in, :body
            key :description, 'Identity to add'
            key :required, true
            schema do
              key :'$ref', :IdentityInput
            end
          end
          response 200 do
            key :description, 'identity response'
            schema do
              key :'$ref', :Identity
            end
          end
          response :default do
            key :description, 'unexpected error'
            schema do
              key :'$ref', :ErrorModel
            end
          end
        end
      end

      swagger_path '/identities/{id}' do
        operation :get do
          key :description, 'Returns identity with given ID'
          key :operationId, 'findIdentityById'
          key :tags, ['identity']
          parameter do
            key :name, :id
            key :in, :path
            key :description, 'ID of identity to fetch'
            key :required, true
            key :type, :string
            key :format, :uuid
          end
          response 200 do
            key :description, 'identity response'
            schema do
              key :'$ref', :Identity
            end
          end
          response :default do
            key :description, 'unexpected error'
            schema do
              key :'$ref', :ErrorModel
            end
          end
        end

        operation :patch do
          key :description, 'Updates a identity'
          key :operationId, 'updateIdentity'
          key :produces, ['application/json']
          key :tags, ['identity']
          parameter do
            key :name, :id
            key :in, :path
            key :description, 'ID of identity to update'
            key :required, true
            key :type, :string
            key :format, :uuid
          end
          parameter do
            key :name, :identity
            key :in, :body
            key :description, 'Identity to update'
            key :required, true
            schema do
              key :'$ref', :IdentityInput
            end
          end
          response 200 do
            key :description, 'identity response'
            schema do
              key :'$ref', :Identity
            end
          end
          response :default do
            key :description, 'unexpected error'
            schema do
              key :'$ref', :ErrorModel
            end
          end
        end
      end

      swagger_path '/identities/search' do
        operation :get do
          key :description, 'Returns a paginated list of identities matching the given search parameters'
          key :operationId, 'searchIdentities'
          key :produces, ['application/json']
          key :tags, ['identity']
          parameter do
            key :name, :given_name
            key :in, :query
            key :description, 'Given name'
            key :required, false
            key :type, :string
          end
          parameter do
            key :name, :middle_names
            key :in, :query
            key :description, 'Middle names'
            key :required, false
            key :type, :string
          end
          parameter do
            key :name, :surname
            key :in, :query
            key :description, 'Surname'
            key :required, false
            key :type, :string
          end
          parameter do
            key :name, :date_of_birth
            key :in, :query
            key :description, 'Date of birth'
            key :required, false
            key :type, :string
            key :format, 'date'
          end
          parameter do
            key :name, :gender
            key :in, :query
            key :description, 'Gender'
            key :required, false
            key :type, :string
          end
          parameter do
            key :name, :noms_id
            key :in, :query
            key :description, 'NOMS ID'
            key :required, false
            key :type, :string
          end
          parameter do
            key :name, :pnc_number
            key :in, :query
            key :description, 'PNC number'
            key :required, false
            key :type, :string
          end
          parameter do
            key :name, :cro_number
            key :in, :query
            key :description, 'CRO number'
            key :required, false
            key :type, :string
          end
          parameter do
            key :name, :establishment_code
            key :in, :query
            key :description, 'Establishment code'
            key :required, false
            key :type, :string
          end
          parameter do
            key :name, :page
            key :in, :query
            key :description, 'Page to return'
            key :required, false
            key :type, :integer
            key :format, :int32
          end
          parameter do
            key :name, :per_page
            key :in, :query
            key :description, 'Per page number of results'
            key :required, false
            key :type, :integer
            key :format, :int32
          end
          response 200 do
            key :description, 'A list of identities'
            schema do
              key :type, :array
              items do
                key :'$ref', :Identity
              end
            end
          end
          response :default do
            key :description, 'unexpected error'
            schema do
              key :'$ref', :ErrorModel
            end
          end
        end
      end

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

        if @identity.update(identity_params)
          render json: { success: true }, status: 200
        else
          render json: { error: @identity.errors }, status: 422
        end
      end

      private

      def offender
        offender_params = identity_params.extract!(:noms_id, :nationality_code, :establishment_code)
        @offender ||=
          if identity_params[:offender_id]
            Offender.find(identity_params[:offender_id])
          else
            Offender.create(offender_params)
          end
      end

      def create_identity
        @identity = offender.identities.build(identity_params.except(:noms_id, :nationality_code, :establishment_code))
        if @identity.save
          update_offender
          render json: { id: @identity.id, offender_id: offender.id }, status: :created
        else
          render json: { error: @identity.errors }, status: 422
        end
      end

      def update_offender
        offender.update_attribute(:current_identity, @identity) unless identity_params[:offender_id]
      end

      def identity_params
        params.require(:identity).permit(
          :offender_id, :nomis_offender_id, :noms_id,
          :given_name, :middle_names, :surname, :title, :suffix,
          :date_of_birth, :gender, :nationality_code,
          :pnc_number, :cro_number, :establishment_code
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
