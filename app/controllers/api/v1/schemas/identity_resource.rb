module IdentityResource
  def self.included(base)
    base.class_eval do
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
            key :name, :given_name_1
            key :in, :query
            key :description, 'Given name 1'
            key :required, false
            key :type, :string
          end
          parameter do
            key :name, :given_name_2
            key :in, :query
            key :description, 'Given name 2'
            key :required, false
            key :type, :string
          end
          parameter do
            key :name, :given_name_3
            key :in, :query
            key :description, 'Given name 3'
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
            key :name, :date_of_birth_from
            key :in, :query
            key :description, 'Date of birth from'
            key :required, false
            key :type, :string
            key :format, 'date'
          end
          parameter do
            key :name, :date_of_birth_to
            key :in, :query
            key :description, 'Date of birth to'
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
            key :name, :ethnicity_code
            key :in, :query
            key :description, 'Establishment code'
            key :required, false
            key :type, :string
          end
          parameter do
            key :name, :name_switch
            key :in, :query
            key :description, 'First/Last name switch'
            key :required, false
            key :type, :string
          end
          parameter do
            key :name, :exact_surname
            key :in, :query
            key :description, 'Exact surname'
            key :required, false
            key :type, :string
          end
          parameter do
            key :name, :name_variation
            key :in, :query
            key :description, 'Name variation'
            key :required, false
            key :type, :string
          end
          parameter do
            key :name, :soundex
            key :in, :query
            key :description, 'Soundex search'
            key :required, false
            key :type, :string
          end
          parameter do
            key :name, :count
            key :in, :query
            key :description, 'Group count by surname'
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

      swagger_path '/identities/inactive' do
        operation :get do
          key :description, 'Returns a paginated list of inactive identities'
          key :operationId, 'inactiveIdentities'
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
          response 200 do
            key :description, 'A list of inactive identities'
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

      swagger_path '/identities/blank_noms_offender_id' do
        operation :get do
          key :description, 'Returns a paginated list of identities with blank noms_offender_id'
          key :operationId, 'blankNomsOffenderIdIdentities'
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
          response 200 do
            key :description, 'A list of identities with blank noms_offender_id'
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

      swagger_path '/identities/{id}' do
        operation :delete do
          key :description, 'Deletes an identity'
          key :operationId, 'deleteIdentity'
          key :produces, ['application/json']
          key :tags, ['identity']
          parameter do
            key :name, :id
            key :in, :path
            key :description, 'ID of identity to delete'
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
      end

      swagger_path '/identities/{id}/activate' do
        operation :patch do
          key :description, 'Activates an identity'
          key :operationId, 'activateIdentity'
          key :produces, ['application/json']
          key :tags, ['identity']
          parameter do
            key :name, :id
            key :in, :path
            key :description, 'ID of identity to activate'
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
      end

      swagger_path '/identities/{id}/make_current' do
        operation :patch do
          key :description, 'Sets an identity as current identity of the offender'
          key :operationId, 'currentIdentity'
          key :produces, ['application/json']
          key :tags, ['identity']
          parameter do
            key :name, :id
            key :in, :path
            key :description, 'ID of identity to make offender current identity'
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
      end
    end
  end
end
