require_relative 'boot'

require 'rails/all'
require 'rack/throttle'
require_relative '../app/middleware/api_throttle'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OffendersApi
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.middleware.use ApiThrottle, max: 60

    config.autoload_paths << "#{Rails.root}/app/controllers/api/v1/schemas"
    config.autoload_paths << "#{Rails.root}/app/models/schemas"

    config.app_title = 'Offenders API'
    config.proposition_title = 'Offenders API'
    config.phase = 'beta'
    config.product_type = 'service'
    config.feedback_url = ''

    config.active_job.queue_adapter = :sidekiq

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'London'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    # config.active_record.raise_in_transactional_callbacks = true

    config.generators do |g|
      g.view_specs false
      g.helper_specs false
    end

    ActionView::Base.default_form_builder = GovukElementsFormBuilder::FormBuilder
  end
end
