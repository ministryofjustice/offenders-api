class Offender < ActiveRecord::Base
  include Swagger::Blocks
  include OffenderModel

  has_paper_trail

  belongs_to :current_identity, class_name: 'Identity', dependent: :destroy
  has_many :identities, dependent: :destroy

  validates :noms_id, presence: true, uniqueness: true

  scope :updated_after, ->(time) { where('updated_at > ?', time) }
  scope :active, -> { joins(:current_identity).where("identities.status": Identity::STATUSES[:active]) }
  scope :inactive, -> { joins(:current_identity).where("identities.status": Identity::STATUSES[:inactive]) }

  delegate :given_name, :middle_names, :surname, :title, :suffix, :date_of_birth, :gender, :pnc_number, :cro_number,
           to: :current_identity, allow_nil: true

  def self.search(params)
    distinct.joins(:identities).where(params).order(:noms_id)
  end
end
