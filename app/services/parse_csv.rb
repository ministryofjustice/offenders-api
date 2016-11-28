module ParseCsv
  class ParsingError < StandardError; end
  class MalformedHeaderError < StandardError; end

  PRISONERS_HEADERS = %w(
    NOMS_NUMBER DATE_OF_BIRTH GIVEN_NAME_1 GIVEN_NAME_2 GIVEN_NAME_3 SURNAME SALUTATION
    GENDER_CODE PNC_ID NATIONALITY_CODE ETHNIC_CODE ETHNIC_DESCRIPTION
    SEXUAL_ORIENTATION_CODE SEXUAL_ORIENATION_DESCRIPTION
    CRIMINAL_RECORDS_OFFICE_NUMBER ESTABLISHMENT_CODE
  ).freeze

  ALIASES_HEADERS = %w(
    NOMS_NUMBER GIVEN_NAME_1 GIVEN_NAME_2 GIVEN_NAME_3 SURNAME DATE_OF_BIRTH GENDER_CODE
  ).freeze

  module_function

  def call(data)
    require 'csv'

    csv = CSV.parse(data, headers: true)

    Identity.delete_all if csv.headers == ALIASES_HEADERS

    csv.each_with_index do |row, line_number|
      import_offender_or_identity(csv.headers, row, line_number + 1)
    end
  end

  class << self
    private

    def import_offender_or_identity(headers, row, line_number)
      if headers == PRISONERS_HEADERS
        update_or_create_offender(row)
      elsif headers == ALIASES_HEADERS
        create_identity(row)
      else
        raise MalformedHeaderError
      end
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound, ArgumentError
      file_name = (headers == PRISONERS_HEADERS ? 'offenders' : 'identities')
      raise(ParsingError, "Error parsing line #{line_number} on #{file_name} file")
    end

    def update_or_create_offender(row)
      offender = Offender.find_by(noms_id: row['NOMS_NUMBER'])
      if offender
        offender.update_attributes(offender_attributes_from(row))
      else
        Offender.create!(offender_attributes_from(row))
      end
    end

    def create_identity(row)
      offender = Offender.find_by!(noms_id: row['NOMS_NUMBER'])
      offender.identities.create!(identity_attributes_from(row))
    end

    def offender_attributes_from(row)
      {
        noms_id: row['NOMS_NUMBER'],
        given_name: row['GIVEN_NAME_1'],
        middle_names: middle_names(row['GIVEN_NAME_2'], row['GIVEN_NAME_3']),
        surname: row['SURNAME'],
        title: row['SALUTATION'],
        date_of_birth: Date.parse(row['DATE_OF_BIRTH']),
        gender: row['GENDER_CODE'],
        pnc_number: row['PNC_ID'],
        nationality_code: row['NATIONALITY_CODE'],
        cro_number: row['CRIMINAL_RECORDS_OFFICE_NUMBER'],
        establishment_code: row['ESTABLISHMENT_CODE']
      }
    end

    def identity_attributes_from(row)
      {
        given_name: row['GIVEN_NAME_1'],
        middle_names: middle_names(row['GIVEN_NAME_2'], row['GIVEN_NAME_3']),
        surname: row['SURNAME'],
        gender: row['GENDER_CODE'],
        date_of_birth: Date.parse(row['DATE_OF_BIRTH'])
      }
    end
  end

  def middle_names(second_name, third_name)
    [second_name, third_name].reject(&:blank?).join(', ')
  end
end
