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

  default_scope { includes(:offender) }

  scope :active, -> { where(status: STATUSES[:active]) }
  scope :inactive, -> { where(status: STATUSES[:inactive]) }
  scope :blank_noms_offender_id, -> { where(noms_offender_id: [nil, '']) }
  scope :nicknames, ->(term) { where(given_name: Nickname.for(term.upcase).map(&:name)) }
  scope :soundex, ->(term) { where('SOUNDEX(surname) = SOUNDEX(?)', term.upcase) }

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

  def current?
    offender.current_identity_id == id
  end
  alias current current?
end
