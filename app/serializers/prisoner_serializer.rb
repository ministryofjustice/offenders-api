class PrisonerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :noms_id, :given_name, :middle_names,
    :surname, :title, :suffix, :date_of_birth, :gender, :pnc_number,
    :nationality_code, :cro_number, :created_at, :updated_at, :links

  def links
    [
      {
        rel: :self,
        href: api_prisoner_path(object)
      }
    ]
  end
end
