class NotificationMailer < ApplicationMailer
  def import_failed(import, errors=[])
    @import = import
    @errors = errors
    mail(to: 'single-offender-identity@digital.justice.gov.uk', subject: 'Import failed')
  end
end
