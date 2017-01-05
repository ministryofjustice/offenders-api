class IdentitySerializer < ActiveModel::Serializer
  attributes :id, :offender_id, :noms_offender_id, :noms_id, :nationality_code, :establishment_code,
             :title, :given_name, :middle_names, :surname, :suffix, :date_of_birth, :gender,
             :pnc_number, :cro_number, :current, :status
end
