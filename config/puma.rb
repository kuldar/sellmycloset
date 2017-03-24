# With a typical Rails memory footprint, you can expect to run 2-4 Puma worker processes on a free, hobby or standard-1x dyno.
workers Integer(ENV['WEB_CONCURRENCY'] || 2)

# Each Puma worker will be able to spawn up to the maximum number of threads you specify.
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

# Preloading your application reduces the startup time of individual Puma worker processes
# https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#preload-app
preload_app!

# Tell Puma how to start your rack app
# This may not be needed on newer versions of Puma.
rackup DefaultRackup

# Specifies the port that Puma will listen on to receive requests, default is 3000
port ENV['PORT'] || 3000

# Specifies the `environment` that Puma will run in
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end

# Allow puma to be restarted by `rails restart` command
plugin :tmp_restart