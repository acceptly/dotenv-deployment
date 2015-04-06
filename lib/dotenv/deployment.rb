require "dotenv"
require "dotenv/deployment/version"

rails_root = Rails.root || Dir.pwd if defined?(Rails)

# Load defaults from .env or *.env in config
Dotenv.load('.env')
Dotenv.load(*Dir.glob("#{rails_root}/config/**/*.env")) if defined?(Rails)

# Override any existing variables if an environment-specific file exists
if environment = ENV['RACK_ENV'] || (defined?(Rails) && Rails.env)
  environment = 'circle' if ENV['CIRCLECI']

  Dotenv.overload(".env.#{environment}")
  if defined?(Rails)
    config_env = Dir.glob("#{rails_root}/config/**/*.env.#{environment}", File::FNM_DOTMATCH)
    Dotenv.overload(*config_env) if config_env.any?
  end

  Dotenv.overload(".env.#{environment}.mine")
  if defined?(Rails)
    config_env = Dir.glob("#{rails_root}/config/**/*.env.#{environment}.mine", File::FNM_DOTMATCH)
    Dotenv.overload(*config_env) if config_env.any?
  end

end
