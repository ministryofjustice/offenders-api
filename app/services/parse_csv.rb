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

    Alias.delete_all if csv.headers == ALIASES_HEADERS

    csv.each_with_index do |row, line_number|
      import_prisoner_or_alias(csv.headers, row, line_number + 1)
    end
  end

  class << self
    private

    def import_prisoner_or_alias(headers, row, line_number)
      if headers == PRISONERS_HEADERS
        update_or_create_prisoner(row)
      elsif headers == ALIASES_HEADERS
        create_alias(row)
      else
        raise MalformedHeaderError
      end
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound, ArgumentError
      file_name = (headers == PRISONERS_HEADERS ? 'prisoners' : 'aliases')
      raise(ParsingError, "Error parsing line #{line_number} on #{file_name} file")
    end

    def update_or_create_prisoner(row)
      prisoner = Prisoner.find_by(noms_id: row['NOMS_NUMBER'])
      if prisoner
        prisoner.update_attributes(prisoner_attributes_from(row))
      else
        Prisoner.create!(prisoner_attributes_from(row))
      end
    end

    def create_alias(row)
      prisoner = Prisoner.find_by!(noms_id: row['NOMS_NUMBER'])
      prisoner.aliases.create!(alias_attributes_from(row))
    end

    def prisoner_attributes_from(row)
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

    def alias_attributes_from(row)
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
