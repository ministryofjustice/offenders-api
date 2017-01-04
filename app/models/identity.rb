class Identity < ActiveRecord::Base
  include Swagger::Blocks
  include IdentityModel

  STATUSES = {
    deleted: 'deleted',
    inactive: 'inactive',
    active: 'active'
  }.freeze

  has_paper_trail

  belongs_to :offender, touch: true

  validates :offender, presence: true
  validates :given_name, presence: true
  validates :surname, presence: true
  validates :date_of_birth, presence: true
  validates :gender, presence: true
  validates :status, inclusion: { in: STATUSES.values }

  scope :active, -> { where("status = 'active'") }
  scope :inactive, -> { where("status = 'inactive'") }

  delegate :noms_id, :nationality_code, :establishment_code, to: :offender

  def self.search(params)
    SearchIdentities.new(params).call
  end

  def make_active!
    update_attribute(:status, STATUSES[:active])
  end

  def soft_delete!
    update_attribute(:status, STATUSES[:deleted])
  end
end
