require "dotenv"
require "dotenv/deployment/version"

module Dotenv
  module Deployment
    class << self

      def log(*files)
        files.each do |file|
          puts "[DOTENV] Trying to load #{file}"
        end
      end

      def load(*files)
        log         *files
        Dotenv.load *files
      end

      def overload(*files)
        log             *files
        Dotenv.overload *files
      end

      def run!
        rails_root = Rails.root || Dir.pwd if defined?(Rails)

        # Load defaults from .env or *.env in config
        load('.env')
        load(*Dir.glob("#{rails_root}/config/**/*.env")) if defined?(Rails)

        # Override any existing variables if an environment-specific file exists
        if environment = ENV['RACK_ENV'] || (defined?(Rails) && Rails.env)
          environment = 'circle' if ENV['CIRCLECI']

          overload(".env.#{environment}")
          if defined?(Rails)
            config_env = Dir.glob("#{rails_root}/config/**/*.env.#{environment}", File::FNM_DOTMATCH)
            overload(*config_env) if config_env.any?
          end

          overload(".env.#{environment}.mine")
          if defined?(Rails)
            config_env = Dir.glob("#{rails_root}/config/**/*.env.#{environment}.mine", File::FNM_DOTMATCH)
            overload(*config_env) if config_env.any?
          end
        end
      end

    end

    run!

  end
end