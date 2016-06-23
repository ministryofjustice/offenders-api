class Prisoner < ActiveRecord::Base
  # field :noms_id, type: String
  # field :offender_id, type: String
  # field :given_name, type: String
  # field :middle_names, type: String
  # field :surname, type: String
  # field :title, type: String
  # field :suffix, type: String
  # field :date_of_birth, type: Date
  # field :gender, type: String
  # field :pnc_number, type: String
  # field :nationality, type: String
  # field :ethnicity, type: String
  # field :languages, type: Array
  # field :requires_interpreter, type: Boolean
  # field :sexual_orientation, type: String

  has_many :aliases, dependent: :destroy
end
