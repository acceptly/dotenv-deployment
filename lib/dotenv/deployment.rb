require "dotenv"
require "dotenv/deployment/version"

# Load defaults from .env or *.env in config
configs = *Dir.glob("#{Rails.root}/config/**/*.env") if defined?(Rails)
Dotenv.load '.env', configs

# Override any existing variables if an environment-specific file exists
environment = ENV['RACK_ENV'] || (defined?(Rails) && Rails.env)
configs.map! {|e| e + ".#{environment}"} if configs
Dotenv.overload ".env.#{environment}", configs if environment
