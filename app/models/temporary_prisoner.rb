class TemporaryPrisoner < ActiveRecord::Base
  validates :noms_id, presence: true
  validates :given_name, presence: true
  validates :surname, presence: true
  validates :date_of_birth, presence: true
  validates :gender, presence: true
end
