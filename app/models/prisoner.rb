class Prisoner < ActiveRecord::Base
  has_many :aliases, dependent: :destroy

  validates :offender_id, uniqueness: { case_sensitive: false }
  validates :noms_id, uniqueness: { case_sensitive: false }
  validates :pnc_number, uniqueness: { case_sensitive: false }
end
