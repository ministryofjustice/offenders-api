class IdentitySerializer < ActiveModel::Serializer
  attributes :id, :offender_id, :nomis_offender_id,
             :title, :given_name, :middle_names, :surname, :suffix, :date_of_birth, :gender,
             :pnc_number, :cro_number
end
