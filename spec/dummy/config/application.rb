require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie" unless Gem.loaded_specs["rails"].version.to_s.start_with?("7.")
# require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)
require "peak_flow_utils"

module Dummy; end

class Dummy::Application < Rails::Application
  # Initialize configuration defaults for originally generated Rails version.
  if Gem.loaded_specs["rails"].version.to_s.start_with?("7.")
    config.load_defaults 7.0
  else
    config.load_defaults 6.0
  end

  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration can go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded after loading
  # the framework and any gems in your application.
end
