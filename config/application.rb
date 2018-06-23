require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module My3605
  class Application < Rails::Application

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**/*.yml').to_s]
    config.i18n.available_locales = [:en, :de]
    config.i18n.default_locale = :de

    # Use delayed job background processing for all environments
    config.active_job.queue_adapter = :delayed_job

    # Use custom error pages
    config.exceptions_app = self.routes
  end
end
