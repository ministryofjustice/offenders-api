class NotificationMailer < ApplicationMailer
  default to: 'single-offender-identity@digital.justice.gov.uk'

  def import_failed(import)
    @import = import
    @error = import.error_log
    mail(subject: "Import failed (#{ENV['HTTP_HOST']})")
  end

  def import_not_performed
    mail(subject: "Import not performed in the last 24 hours (#{ENV['HTTP_HOST']})")
  end
end
