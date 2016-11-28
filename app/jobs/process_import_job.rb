class ProcessImportJob < ActiveJob::Base
  queue_as :default

  def perform(import)
    ImportOffenders.call(import)
  end
end
