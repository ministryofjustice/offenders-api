class OffenderSerializer < ActiveModel::Serializer
  attributes :id, :noms_id, :nationality_code, :establishment_code,
             :title, :given_name_1, :given_name_2, :given_name_3, :surname, :suffix, :date_of_birth, :gender,
             :pnc_number, :cro_number, :ethnicity_code, :created_at, :updated_at
end
