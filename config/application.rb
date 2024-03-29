require_relative 'boot'
require 'rails/all'

# Require all the gems listed in Gemfile
Bundler.require(*Rails.groups)

module SellMyCloset
  class Application < Rails::Application
  
    # Set locale
    config.i18n.default_locale = ENV['LOCALE'] || :et

    # Configuration needed for graceful degradation of form submission.
    config.action_view.embed_authenticity_token_in_remote_forms = true

  end
end
