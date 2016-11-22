class Offender < ActiveRecord::Base
  include Swagger::Blocks

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
  end

  swagger_schema :OffenderInput do
    allOf do
      schema do
        key :'$ref', :Offender
      end
      schema do
        key :required, [:noms_id]
        property :id do
          key :type, :string
          key :format, :uuid
        end
      end
    end
  end

  has_paper_trail

  has_many :identities, dependent: :destroy
  belongs_to :current_identity, class_name: 'Identity', dependent: :destroy

  validates :noms_id, presence: true, uniqueness: true

  scope :updated_after, -> (time) { where('updated_at > ?', time) }

  def self.search(params)
    results = distinct.joins(:identities)
    %i(given_name middle_names surname).each do |field|
      next unless params[field]
      term = params.delete(field)
      results = results.where("identities.#{field} ILIKE :term", term: "%#{term}%")
    end
    %i(gender date_of_birth pnc_number cro_number).each do |field|
      next unless params[field]
      value = params.delete(field)
      results = results.where("identities.#{field} = :value", value: value)
    end
    results.where(params) # .order('identities.surname, identities.given_name, identities.middle_names')
  end

  # def update_identities(identities_params)
  #   return unless identities_params
  #   transaction do
  #     identities.delete_all
  #     identities.create(identities_params)
  #   end
  # end
end
