module OffenderResource
  def self.included(base)
    base.class_eval do
      swagger_path '/offenders' do
        operation :get do
          key :description, 'Returns a paginated list of offenders'
          key :operationId, 'findOffenders'
          key :produces, ['application/json']
          key :tags, ['offender']
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
            key :description, 'Offenders updated after given timestamp'
            key :required, false
            key :type, :string
            key :format, 'date-time'
          end
          response 200 do
            key :description, 'A list of offenders'
            schema do
              key :type, :array
              items do
                key :'$ref', :Offender
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

      swagger_path '/offenders/{id}' do
        operation :get do
          key :description, 'Returns offender with given ID'
          key :operationId, 'findOffenderById'
          key :tags, ['offender']
          parameter do
            key :name, :id
            key :in, :path
            key :description, 'ID of offender to fetch'
            key :required, true
            key :type, :string
            key :format, :uuid
          end
          response 200 do
            key :description, 'offender response'
            schema do
              key :'$ref', :Offender
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

      swagger_path '/offenders/search' do
        operation :get do
          key :description, 'Returns a paginated list of offenders matching the given search parameters'
          key :operationId, 'searchOffenders'
          key :produces, ['application/json']
          key :tags, ['offender']
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
            key :description, 'A list of offenders'
            schema do
              key :type, :array
              items do
                key :'$ref', :Offender
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
    end
  end
end
