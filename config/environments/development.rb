Rails.application.configure do

  # Set default host
  config.after_initialize do
    Rails.application.routes.default_url_options[:host] = 'sellmycloset.dev'
  end

  # Code is reloaded on every request
  config.cache_classes = false

  # Do not eager load code on boot
  config.eager_load = false

  # Show full error reports
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  # Configurate Mailer
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { 
    host: 'sellmycloset.dev', 
    protocol: 'http' 
  }
  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    user_name: ENV['MAILTRAP_USERNAME'],
    password:  ENV['MAILTRAP_PASSWORD'],
    address:  'mailtrap.io',
    domain:   'mailtrap.io',
    port:     '2525',
    authentication: :cram_md5
  }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Active Job que adapter
  # config.active_job.queue_adapter = :async

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
