module ParseCsv
  class ParsingError < StandardError; end
  class MalformedHeaderError < StandardError; end

  PRISONERS_HEADERS = [
    "NOMS Number",
    "Date of Birth",
    "Offender Given Name 1",
    "Offender Given Name 2",
    "Offender Surname",
    "Salutation",
    "Gender Code",
    "PNC ID",
    "Nationality Code",
    "Ethnic Code",
    "Ethnic Description",
    "Sexual Orientation Code",
    "Sexual Orientation Description",
    "Criminal Records Office number"
  ]

  ALIASES_HEADERS = [
    "NOMS Number",
    "Alias Surname",
    "Alias Given Name 1",
    "Alias Given Name 2",
    "Alias Date of Birth",
    "Alias Gender","Alias or Working Name?"
  ]

  module_function

  def call(data)
    require 'csv'
    csv = CSV.parse(data, headers: true)
    csv.each_with_index do |row, line_number|
      import_prisoner_or_alias(csv.headers, row, line_number + 1)
    end
  end

  class << self
    private

    def import_prisoner_or_alias(headers, row, line_number)
      if headers == PRISONERS_HEADERS
        Prisoner.create!(prisoner_attributes_from(row))
      elsif headers == ALIASES_HEADERS
        prisoner = Prisoner.where(noms_id: row['NOMS Number']).first
        prisoner.aliases.create!(alias_attributes_from(row))
      else
        fail MalformedHeaderError
      end
    rescue ActiveRecord::RecordInvalid, ArgumentError
      fail(ParsingError, "Error parsing line #{line_number}")
    end

    def prisoner_attributes_from(row)
      {
        noms_id: row['NOMS Number'],
        given_name: row['Offender Given Name 1'],
        middle_names: row['Offender Given Name 2'],
        surname: row['Offender Surname'],
        title: row['Salutation'],
        date_of_birth: Date.parse(row['Date of Birth']),
        gender: row['Gender Code'],
        pnc_number: row['PNC ID'],
        nationality_code: row['Nationality Code'],
        ethnicity_code: row['Ethnic Code'],
        sexual_orientation_code: row['Sexual Orientation Code'],
        cro_number: row['Criminal Records Office number']
      }
    end

    def alias_attributes_from(row)
      {
        given_name: row['Alias Given Name 1'],
        middle_names: row['Alias Given Name 2'],
        surname: row['Alias Surname'],
        gender: row['Alias Gender'],
        date_of_birth: Date.parse(row['Alias Date of Birth'])
      }
    end
  end
end
