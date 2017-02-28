class IdentitySerializer < ActiveModel::Serializer
  attributes :id, :offender_id, :noms_offender_id, :noms_id, :nationality_code, :establishment_code,
             :title, :given_name_1, :given_name_2, :given_name_3, :surname, :suffix, :date_of_birth, :gender,
             :pnc_number, :cro_number, :ethnicity_code, :current, :status
end
