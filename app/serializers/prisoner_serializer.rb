class PrisonerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :noms_id, :given_name, :middle_names,
    :surname, :title, :suffix, :date_of_birth, :gender, :pnc_number,
    :nationality, :second_nationality, :ethnicity_code, :sexual_orientation,
    :cro_number, :created_at, :updated_at, :links

  def links
    {
      rel: 'prisoners',
      href: api_prisoners_path
    }
  end
end
