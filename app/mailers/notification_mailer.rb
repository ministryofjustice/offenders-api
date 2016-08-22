class NotificationMailer < ApplicationMailer
  def import_failed(import)
    @import = import
    mail(to: 'single-offender-identity@digital.justice.gov.uk', subject: 'Import failed')
  end
end
