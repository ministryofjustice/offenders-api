namespace :import do
  desc 'Retry last import'
  task retry: :environment do
    import = Import.last
    ParseOffenders.call(import.offenders_file.read)
    import.update_attribute(:status, :successful)
    Import.where('id != ?', import.id).destroy_all
  end

  desc 'Remove all imports, uploads and the files'
  task cleanup: :environment do
    Import.destroy_all
    Upload.destroy_all
    directory = Rails.root.join('public', 'uploads', 'import')
    FileUtils.rm_rf(directory)
  end

  desc 'Import sample offender records'
  task sample: :environment do
    file = Rails.root.join('lib', 'assets', 'data', 'data.csv')
    ParseOffenders.call(file.read)
  end

  desc 'Import NOMIS extract, and remove previous records'
  task nomis_extract: :environment do
    Offender.delete_all
    Identity.delete_all
    file = Rails.root.join('lib', 'assets', 'data', 'nomis_extract.csv')
    parse_offenders(file)
  end

  desc 'Check and notify if no import has been performed in the last 24 hours'
  task check: :environment do
    unless Import.where('created_at > ?', 1.day.ago).any?
      NotificationMailer.import_not_performed.deliver_now
    end
  end

  desc 'Import nicknames from Google nickname-and-diminutive-names-lookup'
  task nicknames: :environment do
    uri = URI('https://raw.githubusercontent.com/carltonnorthern/nickname-and-diminutive-names-lookup/master/names.csv')
    file = Net::HTTP.get(uri)
    ParseNicknames.call(file)
  end

  def parse_offenders(file)
    initial_import_log = Rails.root.join('log', 'initial_import.log')
    FileUtils.rm(initial_import_log) if File.exist?(initial_import_log)
    logger = Logger.new(initial_import_log)

    SmarterCSV.process(file, chunk_size: 1000, key_mapping: keys_mapping) do |chunk|
      chunk.each { |row| parse_row(row, logger) }
    end
  end

  def parse_row(row, logger)
    offender = Offender.find_or_create_by(offender_attrs(row))
    identity = offender.identities.create(identity_attrs(row))
    logger.info(row) unless identity
    offender.update(current_identity: identity) if identity && row[:working_name] == 'Y'
  end

  def offender_attrs(row)
    row.slice(:noms_id, :establishment_code, :nationality_code)
       .merge(id: row[:soi_offender_id])
  end

  def identity_attrs(row)
    row.slice(:date_of_birth, :given_name_1, :given_name_2, :given_name_3, :surname,
              :title, :gender, :pnc_number, :cro_number, :nomis_offender_id)
       .merge(id: row[:soi_identity_id], status: 'active')
  end

  def keys_mapping
    {
      noms_number: :noms_id,
      nomis_offender_id: :nomis_offender_id,
      salutation: :title,
      gender_code: :gender,
      pnc_id: :pnc_number,
      criminal_records_office_number: :cro_number
    }
  end
end
