class Prisoner < ActiveRecord::Base
  has_paper_trail

  has_many :aliases, dependent: :destroy

  validates :noms_id, presence: true
  validates :given_name, presence: true
  validates :surname, presence: true
  validates :date_of_birth, presence: true
  validates :gender, presence: true
end
