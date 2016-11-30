class Identity < ActiveRecord::Base
  include Swagger::Blocks
  include IdentityModel

  has_paper_trail

  belongs_to :offender, touch: true

  validates :offender, presence: true
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
