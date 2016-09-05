module Api
  module V1
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
            key :format, :date
          end
          response 200 do
            key :description, 'prisoner response'
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
            key :type, :uuid
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

        updated_after = Time.parse(params[:updated_after]) rescue nil
        @prisoners = @prisoners.updated_after(updated_after) if updated_after

        render json: @prisoners
      end

      def show
        @prisoner = Prisoner.find(params[:id])

        render json: @prisoner
      end
    end
  end
end
