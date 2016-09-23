module Api
  module V1
    # rubocop:disable Metrics/ClassLength
    class PrisonersController < Api::ApplicationController
      include Swagger::Blocks

      swagger_path '/prisoners' do
        operation :get do
          key :description, 'Returns all prisoners from the system that the user has access to'
          key :operationId, 'findPrisoners'
          key :produces, [
            'application/json'
          ]
          key :tags, [
            'prisoner'
          ]
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
          key :produces, [
            'application/json'
          ]
          key :tags, [
            'prisoner'
          ]
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

      swagger_path '/prisoners/search' do
        operation :get do
          key :description, 'Returns all prisoners matching the given noms_ids and dates of birth'
          key :operationId, 'searchPrisoners'
          key :produces, [
            'application/json'
          ]
          key :tags, [
            'prisoner'
          ]
          parameter do
            key :name, :query
            key :in, :query
            key :description, 'array of noms_id, date_of_birth hashes'
            key :required, false
            key :type, :array
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

      swagger_path '/prisoners/{id}' do
        operation :get do
          key :description, 'Returns a single prisoner if the user has access'
          key :operationId, 'findPrisonerById'
          key :tags, [
            'prisoner'
          ]
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
      end

      swagger_path '/prisoners/noms/{id}' do
        operation :get do
          key :description, 'Returns a single prisoner if the user has access'
          key :operationId, 'findPrisonerByNomsId'
          key :tags, [
            'prisoner'
          ]
          parameter do
            key :name, :id
            key :in, :path
            key :description, 'Noms ID of prisoner to fetch'
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
        @prisoners = Prisoner.search(params[:query])

        render json: @prisoners
      end

      def show
        @prisoner = Prisoner.find(params[:id])

        render json: @prisoner
      end

      def noms
        @prisoner = Prisoner.find_by!(noms_id: params[:id].upcase)

        render json: @prisoner
      end

      def create
        @prisoner = Prisoner.new(prisoner_params)

        if @prisoner.save
          render json: { id: @prisoner.id }, status: :created
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
          :pnc_number,
          :nationality_code,
          :cro_number
        )
      end
    end
  end
end
