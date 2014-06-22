module OneSecret
  class Railtie < Rails::Railtie
    config.after_initialize do
      # concern 1 - initialize Encryptor with the correct secret_key_base and optional iv and salt
      default_options = {:key => Rails.application.secrets.secret_key_base}
      Encryptor.default_options.merge!(default_options)

      # concern 2 - decrypt Rails.application.secrets
      Rails.application.secrets.each_pair do |key, value|
        decrypted_value = value.decrypt rescue value
        Rails.application.secrets[key] = decrypted_value
      end

      # concern 3 - rake tasks for set / get
      # concern 4 - security message for people keeping production secret_key_base in secrets.yml
      # concern 5 - copy all Rails.application.secrets to ENV
    end

    generators do
      require_relative "generators/secrets/secrets_generator"
    end
  end
end if defined?(Rails)
