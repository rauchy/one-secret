module OneSecret
  class Railtie < Rails::Railtie
    generators do
      require_relative "generators/secrets/secrets_generator"
    end
  end
end if defined?(Rails)
