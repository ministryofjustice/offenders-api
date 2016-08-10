module ParseCsv
  module_function

  def call(data)
    require 'csv'
    csv = CSV.parse(data, headers: true)
    csv.each do |row|
      import_prisoner_or_alias(csv.headers, row)
    end
  end

  class << self
    private

    def import_prisoner_or_alias(headers, row)
      if headers.include?('Offender Surname')
        Prisoner.create! prisoner_attributes_from(row)
      elsif headers.include?('Alias Surname')
        prisoner = Prisoner.where(noms_id: row['NOMS Number']).first
        prisoner.aliases.create!(alias_attributes_from(row)) if prisoner
      end
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
