class NotificationMailer < ApplicationMailer
  def import_failed(import, error)
    @import = import
    @error = error
    mail(to: 'single-offender-identity@digital.justice.gov.uk', subject: 'Import failed')
  end

  def import_not_performed
    mail(to: 'single-offender-identity@digital.justice.gov.uk', subject: 'Import not performed in the last 24 hours')
  end
end
