class PrisonerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  has_many :aliases

  attributes :id, :noms_id, :title, :given_name, :middle_names, :surname, :suffix,
             :date_of_birth, :gender, :nationality_code, :pnc_number, :cro_number,
             :establishment_code, :aliases, :created_at, :updated_at
end
