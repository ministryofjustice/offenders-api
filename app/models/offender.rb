class Offender < ActiveRecord::Base
  include Swagger::Blocks
  include OffenderModel

  has_paper_trail

  belongs_to :current_identity, class_name: 'Identity', dependent: :destroy
  has_many :identities, dependent: :destroy

  validates :noms_id, presence: true, uniqueness: true

  scope :updated_after, -> (time) { where('updated_at > ?', time) }

  delegate :given_name, :middle_names, :surname, :title, :suffix, :date_of_birth, :gender, :pnc_number, :cro_number,
           to: :current_identity, allow_nil: true

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
end
