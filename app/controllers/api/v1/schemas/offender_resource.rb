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

        # operation :post do
        #   key :description, 'Creates a new offender'
        #   key :operationId, 'addOffender'
        #   key :produces, ['application/json']
        #   key :tags, ['offender']
        #   parameter do
        #     key :name, :offender
        #     key :in, :body
        #     key :description, 'Offender to add'
        #     key :required, true
        #     schema do
        #       key :'$ref', :OffenderInput
        #     end
        #   end
        #   response 200 do
        #     key :description, 'offender response'
        #     schema do
        #       key :'$ref', :Offender
        #     end
        #   end
        #   response :default do
        #     key :description, 'unexpected error'
        #     schema do
        #       key :'$ref', :ErrorModel
        #     end
        #   end
        # end
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

        # operation :patch do
        #   key :description, 'Updates a offender'
        #   key :operationId, 'updateOffender'
        #   key :produces, ['application/json']
        #   key :tags, ['offender']
        #   parameter do
        #     key :name, :id
        #     key :in, :path
        #     key :description, 'ID of offender to update'
        #     key :required, true
        #     key :type, :string
        #     key :format, :uuid
        #   end
        #   parameter do
        #     key :name, :offender
        #     key :in, :body
        #     key :description, 'Offender to update'
        #     key :required, true
        #     schema do
        #       key :'$ref', :OffenderInput
        #     end
        #   end
        #   response 200 do
        #     key :description, 'offender response'
        #     schema do
        #       key :'$ref', :Offender
        #     end
        #   end
        #   response :default do
        #     key :description, 'unexpected error'
        #     schema do
        #       key :'$ref', :ErrorModel
        #     end
        #   end
        # end
      end

      swagger_path '/offenders/search' do
        operation :get do
          key :description, 'Returns a paginated list of offenders matching the given search parameters'
          key :operationId, 'searchOffenders'
          key :produces, ['application/json']
          key :tags, ['offender']
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
