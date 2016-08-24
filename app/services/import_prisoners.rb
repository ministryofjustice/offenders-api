module ImportPrisoners
  module_function

  def call(data, import = nil)
    ParseCsv.call(data)
    if import
      import.update_attribute(:status, :successful)
      Import.where('id != ?', import.id).destroy_all
    end
  rescue Exception => e
    import.update_attribute(:status, :failed) if import
    NotificationMailer.import_failed(import, e.to_s).deliver_now
  end
end
