namespace :export do
  desc 'Generate CSV file with Single Offender IDs paired with NOMIS ids'
  task offenders: :environment do
    require 'csv'

    file = Rails.root.join('lib', 'assets', 'data', 'soi_extract.csv')

    CSV.open(file, 'wb') do |csv|
      csv << %w(noms_offender_id identity_id offender_id)
      Identity.find_each { |identity| csv << [identity.noms_offender_id, identity.id, identity.offender.id] }
    end
  end
end
