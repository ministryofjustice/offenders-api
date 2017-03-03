class Offender < ActiveRecord::Base
  include Swagger::Blocks
  include OffenderModel

  has_paper_trail

  belongs_to :current_identity, class_name: 'Identity', dependent: :destroy
  has_many :identities, dependent: :destroy

  validates :noms_id, presence: true
  validate :uniqueness_of_noms_id

  scope :updated_after, ->(time) { where('updated_at > ?', time) }
  scope :active, -> { not_merged.joins(:current_identity).where("identities.status": Identity::STATUSES[:active]) }
  scope :inactive, -> { not_merged.joins(:current_identity).where("identities.status": Identity::STATUSES[:inactive]) }
  scope :not_merged, -> { where(merged_to_id: nil) }

  delegate :given_name_1, :given_name_2, :given_name_3, :surname, :title, :suffix, :date_of_birth, :gender,
           :pnc_number, :cro_number, :ethnicity_code,
           to: :current_identity, allow_nil: true

  def self.search(params)
    distinct.joins(:identities).where(params).order(:noms_id)
  end

  def uniqueness_of_noms_id
    errors.add(:noms_id, 'ID already taken') if Offender.not_merged.exists?(['noms_id = ? AND id != ?', noms_id, id])
  end

  def merged?
    merged_to_id.present?
  end
end
