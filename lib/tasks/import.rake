require 'csv'

namespace :import do
  desc 'Import sample prisoner records'
  task sample: :environment do
    puts 'Importing sample prisoner records...'

    file = Rails.root.join('lib', 'assets', 'data', 'offenders.csv')
    data = CSV.read(file, headers: true)

    data_groups = data.group_by { |row| row['ROOT_OFFENDER_ID'] }
    data_groups.values.each do |values|
      values.sort_by! { |r| !(r['WORKING_NAME'] || '') }
    end

    data_groups.each do |root_offender_id, rows|
      row = rows.first

      p = Prisoner.create!(
        title: (row['TITLE'].strip rescue nil),
        given_name: (row['FIRST_NAME'].strip rescue nil),
        middle_names: (row['MIDDLE_NAME'].strip rescue nil),
        surname: (row['LAST_NAME'].strip rescue nil),
        suffix: (row['SUFFIX'].strip rescue nil),
        date_of_birth: (Date.strptime(row['BIRTH_DATE'].strip, '%d/%m/%y') rescue nil),
        gender: (row['SEX_CODE'].strip rescue nil),
        noms_id: (row['NOMS_ID'].strip rescue nil),
        ethnicity_code: (row['ETHNICITY_CODE'].strip rescue nil),
        cro_number: (row['CRO_NUMBER'].strip rescue nil),
        pnc_number: (row['PNC_NUMBER'].strip rescue nil),
        nationality_code: (row['NATIONALITY_CODE'].strip rescue nil),
        second_nationality_code: (row['SECOND_NATIONALITY_CODE'].strip rescue nil),
        sexual_orientation_code: (row['SEXUAL_ORIENTATION_CODE'].strip rescue nil)
      )

      puts "PRISONER RECORD CREATED: #{p.noms_id}"

      rows[1..-1].each do |row|
        a = Alias.create!(
          prisoner_id: p.id,
          title: (row['TITLE'].strip rescue nil),
          given_name: (row['FIRST_NAME'].strip rescue nil),
          middle_names: (row['MIDDLE_NAME'].strip rescue nil),
          surname: (row['LAST_NAME'].strip rescue nil),
          suffix: (row['SUFFIX'].strip rescue nil),
          date_of_birth: (Date.strptime(row['BIRTH_DATE'].strip, '%d/%m/%y') rescue nil),
          gender: (row['SEX_CODE'].strip rescue nil),
          ethnicity_code: (row['ETHNICITY_CODE'].strip rescue nil)
        )

        puts "ALIAS RECORD CREATED: #{p.noms_id}"
      end
    end
  end
end
