require 'csv'

namespace :import do
  desc 'Retry last import'
  task retry: :environment do
    import = Import.last
    ParseCsv.call(import.prisoners_file.read)
    ParseCsv.call(import.aliases_file.read)
    import.update_attribute(:status, :successful)
    Import.where('id != ?', import.id).destroy_all
  end

  desc 'Removes all the imports, the uploads and the files'
  task cleanup: :environment do
    Import.destroy_all
    Upload.destroy_all
    directory = Rails.root.join('public', 'uploads', 'import')
    FileUtils.rm_rf(directory)
  end

  desc 'Import sample prisoner records'
  task sample: :environment do
    file = Rails.root.join('lib', 'assets', 'data', 'prisoners.csv')
    ParseCsv.call(file.read)

    file = Rails.root.join('lib', 'assets', 'data', 'aliases.csv')
    ParseCsv.call(file.read)
  end
end
