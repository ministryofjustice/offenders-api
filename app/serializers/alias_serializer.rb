class AliasSerializer < ActiveModel::Serializer
  attributes :title, :given_name, :middle_names, :surname, :suffix, :date_of_birth, :gender
end
