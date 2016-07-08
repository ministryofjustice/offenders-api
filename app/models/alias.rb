class Alias < ActiveRecord::Base
  belongs_to :prisoner

  validates :given_name, presence: true
  validates :surname, presence: true
  validates :date_of_birth, presence: true
  validates :gender, presence: true
end
