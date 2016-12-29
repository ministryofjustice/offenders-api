namespace :import do
  desc 'Retry last import'
  task retry: :environment do
    import = Import.last
    ParseCsv.call(import.offenders_file.read)
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

  desc 'Create 100k offender records with identities'
  task fake_offenders: :environment do
    Offender.destroy_all
    100_000.times do
      offender = FactoryGirl.build(:offender)
      next unless offender.save
      identity = nil
      [1, 2, 3, 4, 5].sample.times do
        identity = FactoryGirl.create(:identity, :active, offender: offender)
      end
      offender.update current_identity: identity
    end
  end

  desc 'Import sample offender records'
  task sample: :environment do
    file = Rails.root.join('lib', 'assets', 'data', 'data.csv')
    ParseCsv.call(file.read)
  end

  desc 'Check and notify if no import has been performed in the last 24 hours'
  task check: :environment do
    unless Import.where('created_at > ?', 1.day.ago).any?
      NotificationMailer.import_not_performed.deliver_now
    end
  end
end
