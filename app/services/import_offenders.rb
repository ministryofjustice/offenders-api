module ImportOffenders
  module_function

  def call(import)
    errors = ParseOffenders.call(import.offenders_file.file.file)
    if errors.any?
      import.update_attribute(:status, :failed)
      import.update_attribute(:error_log, errors.to_json)
      NotificationMailer.import_failed(import).deliver_later
    else
      import.update_attribute(:status, :successful)
      Import.where('id != ?', import.id).destroy_all
    end
  end
end
