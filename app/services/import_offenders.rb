module ImportOffenders
  module_function

  def call(import)
    errors = ParseOffenders.call(import.offenders_file.file.file)
    if errors.any?
      import.update_attribute(:status, :failed)
      NotificationMailer.import_failed(import, errors.join("\n\n")).deliver_now
    else
      import.update_attribute(:status, :successful)
      Import.where('id != ?', import.id).destroy_all
    end
  end
end
