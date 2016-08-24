class ImportProcessor
  include Sidekiq::Worker

  def perform(import_id)
    import = Import.find(import_id)
    ImportPrisoners.call(import.file.read, import)
  end
end
