module OffenderModel
  def self.included(base)
    base.class_eval do
      swagger_schema :Offender do
        key :required, [:id, :noms_id]
        property :id do
          key :type, :string
          key :format, :uuid
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
        property :given_name do
          key :type, :string
        end
        property :middle_names do
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
      end
    end
  end
end
