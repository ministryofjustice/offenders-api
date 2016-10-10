module Api
  module V1
    # rubocop:disable Metrics/ClassLength
    class PrisonersController < Api::ApplicationController
      include Swagger::Blocks

      swagger_path '/prisoners' do
        operation :get do
          key :description, 'Returns all prisoners from the system that the user has access to'
          key :operationId, 'findPrisoners'
          key :produces, ['application/json']
          key :tags, ['prisoner']
          parameter do
            key :name, :page
            key :in, :query
            key :description, 'page to return'
            key :required, false
            key :type, :integer
            key :format, :int32
          end
          parameter do
            key :name, :per_page
            key :in, :query
            key :description, 'per page number of results to return'
            key :required, false
            key :type, :integer
            key :format, :int32
          end
          parameter do
            key :name, :updated_after
            key :in, :query
            key :description, 'records updated after timestamp to return'
            key :required, false
            key :type, :string
            key :format, 'date-time'
          end
          response 200 do
            key :description, 'A list of prisoners'
            schema do
              key :type, :array
              items do
                key :'$ref', :Prisoner
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
          key :description, 'Creates a new prisoner'
          key :operationId, 'addPrisoner'
          key :produces, ['application/json']
          key :tags, ['prisoner']
          parameter do
            key :name, :prisoner
            key :in, :body
            key :description, 'Prisoner to add'
            key :required, true
            schema do
              key :'$ref', :PrisonerInput
            end
          end
          response 200 do
            key :description, 'prisoner response'
            schema do
              key :'$ref', :Prisoner
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

      swagger_path '/prisoners/{id}' do
        operation :get do
          key :description, 'Returns a single prisoner if the user has access'
          key :operationId, 'findPrisonerById'
          key :tags, ['prisoner']
          parameter do
            key :name, :id
            key :in, :path
            key :description, 'ID of prisoner to fetch'
            key :required, true
            key :type, :string
            key :format, :uuid
          end
          response 200 do
            key :description, 'prisoner response'
            schema do
              key :'$ref', :Prisoner
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
          key :description, 'Updates a prisoner'
          key :operationId, 'updatePrisoner'
          key :produces, ['application/json']
          key :tags, ['prisoner']
          parameter do
            key :name, :id
            key :in, :path
            key :description, 'ID of prisoner to update'
            key :required, true
            key :type, :string
            key :format, :uuid
          end
          parameter do
            key :name, :prisoner
            key :in, :body
            key :description, 'Prisoner to update'
            key :required, true
            schema do
              key :'$ref', :PrisonerInput
            end
          end
          response 200 do
            key :description, 'prisoner response'
            schema do
              key :'$ref', :Prisoner
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

      swagger_path '/prisoners/search' do
        operation :get do
          key :description, 'Returns all prisoners matching the given noms_ids and dates of birth'
          key :operationId, 'searchPrisoners'
          key :produces, ['application/json']
          key :tags, ['prisoner']
          parameter do
            key :name, :given_name
            key :in, :query
            key :description, 'given name'
            key :required, false
            key :type, :string
          end
          parameter do
            key :name, :middle_names
            key :in, :query
            key :description, 'middle names'
            key :required, false
            key :type, :string
          end
          parameter do
            key :name, :surname
            key :in, :query
            key :description, 'surname'
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
            key :name, :page
            key :in, :query
            key :description, 'page to return'
            key :required, false
            key :type, :integer
            key :format, :int32
          end
          parameter do
            key :name, :per_page
            key :in, :query
            key :description, 'per page number of results to return'
            key :required, false
            key :type, :integer
            key :format, :int32
          end
          response 200 do
            key :description, 'A list of prisoners'
            schema do
              key :type, :array
              items do
                key :'$ref', :Prisoner
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
        @prisoners = Prisoner.page(params[:page]).per(params[:per_page])

        updated_after =
          begin
            Time.parse(params[:updated_after])
          rescue ArgumentError, TypeError
            nil
          end
        @prisoners = @prisoners.updated_after(updated_after) if updated_after

        render json: @prisoners
      end

      def search
        @prisoners = Prisoner.search(search_params).page(params[:page]).per(params[:per_page])

        render json: @prisoners
      end

      def show
        @prisoner = Prisoner.find(params[:id])

        render json: @prisoner
      end

      def create
        @prisoner = Prisoner.new(prisoner_params.except(:aliases))

        if @prisoner.save
          @prisoner.update_aliases(prisoner_params[:aliases])
          render json: { id: @prisoner.id }, status: :created
        else
          render json: { error: @prisoner.errors }, status: 422
        end
      end

      def update
        @prisoner = Prisoner.find(params[:id])

        if @prisoner.update(prisoner_params.except(:aliases))
          @prisoner.update_aliases(prisoner_params[:aliases])
          render json: { success: true }, status: 200
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
          :nationality_code,
          :pnc_number,
          :cro_number,
          :establishment_code,
          aliases: [:given_name, :middle_names, :surname, :title, :suffix, :gender, :date_of_birth]
        )
      end

      def search_params
        params.permit(
          :noms_id,
          :given_name,
          :middle_names,
          :surname
          # :date_of_birth,
          # :pnc_number,
          # :cro_number,
          # :establishment_code,
        )
      end
    end
  end
end
