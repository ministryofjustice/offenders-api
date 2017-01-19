module ImportOffenders
  module_function

  def call(import)
    ParseOffenders.call(import.offenders_file.read)
    import.update_attribute(:status, :successful)
    Import.where('id != ?', import.id).destroy_all
  rescue StandardError => e
    import&.update_attribute(:status, :failed)
    NotificationMailer.import_failed(import, e.to_s).deliver_now
  end
end
