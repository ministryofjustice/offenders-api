class AliasSerializer < ActiveModel::Serializer
  attributes :given_name, :middle_names, :surname, :date_of_birth, :gender
end
