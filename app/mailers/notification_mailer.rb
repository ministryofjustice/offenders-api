class NotificationMailer < ApplicationMailer
  def import_failed(import, error)
    @import = import
    @error = error
    mail(to: 'single-offender-identity@digital.justice.gov.uk', subject: 'Import failed')
  end
end
