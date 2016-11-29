class Identity < ActiveRecord::Base
  include Swagger::Blocks

  # rubocop:disable Metrics/BlockLength
  swagger_schema :Identity do
    key :required, [:id, :given_name, :surname, :date_of_birth, :gender]
    property :id do
      key :type, :integer
      key :format, :int32
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
    property :noms_id do
      key :type, :string
    end
  end

  swagger_schema :IdentityInput do
    allOf do
      schema do
        key :'$ref', :Identity
      end
      schema do
        key :required, [:noms_id, :given_name, :surname, :date_of_birth, :gender]
        property :id do
          key :type, :string
          key :format, :uuid
        end
      end
    end
  end

  has_paper_trail

  belongs_to :offender

  validates :given_name, presence: true
  validates :surname, presence: true
  validates :date_of_birth, presence: true
  validates :gender, presence: true

  delegate :noms_id, :nationality_code, :establishment_code, to: :offender

  def self.search(params)
    results = joins(:offender)
    %i(given_name middle_names surname).each do |field|
      next unless params[field]
      term = params.delete(field)
      results = results.where("#{field} ILIKE :term", term: "%#{term}%")
    end
    %i(noms_id nationality_code establishment_code).each do |field|
      next unless params[field]
      value = params.delete(field)
      results = results.where("offenders.#{field} = :value", value: value)
    end
    results.where(params).order(:surname, :given_name, :middle_names)
  end
end
