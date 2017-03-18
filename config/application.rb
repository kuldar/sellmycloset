require_relative 'boot'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SellMyCloset
  class Application < Rails::Application
  
    # Set locale
    config.i18n.default_locale = :et

    # Configuration needed for graceful degradation of form submission.
    config.action_view.embed_authenticity_token_in_remote_forms = true

  end
end
