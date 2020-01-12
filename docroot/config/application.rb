# frozen_string_literal: true

require_relative "boot"

require "rubygems"
require "rails/all"
require "kindle_highlights"
require "bundler"
require "fileutils"
require "json"
require "cgi"
require "mail"
require "htmlentities"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Commonplace
  class Application < Rails::Application
    # Running Rails in API only mode.
    # config.api_only = true

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.before_configuration do
      env_file = File.join(Rails.root, "config", "local_env.yml")
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exist?(env_file)
    end
  end
end
