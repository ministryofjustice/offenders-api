class OffenderSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  has_many :identities

  attributes :id, :noms_id, :nationality_code, :establishment_code, :identities, :created_at, :updated_at
end
