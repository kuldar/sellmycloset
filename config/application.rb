require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SellMyCloset
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    if Rails.env.staging?
    	config.i18n.default_locale = :et
	  else
	    config.i18n.default_locale = :et
	  end
    # config.i18n.default_locale = :en

    # Configuration needed for graceful degradation of form submission.
    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end
