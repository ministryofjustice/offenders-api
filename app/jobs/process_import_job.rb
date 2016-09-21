class ProcessImportJob < ActiveJob::Base
  queue_as :default

  def perform(import)
    ImportPrisoners.call(import)
  end
end
