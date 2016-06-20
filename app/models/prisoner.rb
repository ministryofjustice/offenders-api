class Prisoner
  include Mongoid::Document

  field :noms_id, type: String
  field :offender_id, type: String
  field :given_name, type: String
  field :middle_names, type: String
  field :surname, type: String
  field :title, type: String
  field :suffix, type: String
  field :date_of_birth, type: Date
  field :gender, type: String
  field :pnc_number, type: String

  embeds_many :aliases
end
