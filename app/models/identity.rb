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
    results = joins(:offender)
    given_name_surname = [params[:given_name], params[:surname]].compact.map(&:upcase)
    %i(given_name middle_names surname noms_id nationality_code
       establishment_code date_of_birth_from date_of_birth_to).each do |field|
      next unless params[field]
      value = params.delete(field)
      results = case field
                when :given_name, :surname
                  if params[:name_switch]
                    results.where(field => given_name_surname)
                  else
                    results.where("#{field} ILIKE ?", value)
                  end
                when :middle_names
                  results.where("#{field} ILIKE ?", value)
                when :date_of_birth_from
                  results.where('date_of_birth >= ?', value)
                when :date_of_birth_to
                  results.where('date_of_birth <= ?', value)
                when :noms_id, :nationality_code, :establishment_code
                  results.where("offenders.#{field} = ?", value)
                end
    end
    results.where(params.except(:name_switch)).order(:surname, :given_name, :middle_names)
  end

  def make_active!
    update_attribute(:status, STATUSES[:active])
  end

  def soft_delete!
    update_attribute(:status, STATUSES[:deleted])
  end
end
