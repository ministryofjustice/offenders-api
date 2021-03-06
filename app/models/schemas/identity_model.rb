module IdentityModel
  def self.included(base)
    base.class_eval do
      swagger_schema :Identity do
        key :required, [:id, :given_name, :surname, :date_of_birth, :gender]
        property :id do
          key :type, :string
          key :format, :uuid
        end
        property :offender_id do
          key :type, :string
          key :format, :uuid
        end
        property :nomis_offender_id do
          key :type, :string
        end
        property :noms_id do
          key :type, :string
        end
        property :nationality_code do
          key :type, :string
        end
        property :establishment_code do
          key :type, :string
        end
        property :title do
          key :type, :string
        end
        property :given_name_1 do
          key :type, :string
        end
        property :given_name_2 do
          key :type, :string
        end
        property :given_name_3 do
          key :type, :string
        end
        property :surname do
          key :type, :string
        end
        property :suffix do
          key :type, :string
        end
        property :date_of_birth do
          key :type, :string
          key :format, :date
        end
        property :gender do
          key :type, :string
        end
        property :pnc_number do
          key :type, :string
        end
        property :cro_number do
          key :type, :string
        end
        property :ethnicity_code do
          key :type, :string
        end
        property :current do
          key :type, :boolean
        end
        property :status do
          key :type, :string
        end
      end

      swagger_schema :IdentityInput do
        allOf do
          schema do
            key :'$ref', :Identity
          end
          schema do
            key :required, [:noms_id, :given_name_1, :surname, :date_of_birth, :gender]
            property :id do
              key :type, :string
              key :format, :uuid
            end
          end
        end
      end
    end
  end
end
