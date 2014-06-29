module OneSecret
  class Railtie < Rails::Railtie
    config.before_initialize do
      # concern 1 - initialize Encryptor with the correct secret_key_base and optional iv and salt
      default_options = {:key => Rails.application.secrets.secret_key_base}
      Encryptor.default_options.merge!(default_options)
#      Secret.key = KeyResolution.try(:env, :rails, :stdin)

      # concern 2 - decrypt Rails.application.secrets
      Rails.application.secrets.each_pair do |key, value|
        decrypted_value = Secret.load(value)
        Rails.application.secrets[key] = decrypted_value
      end

      # concern 4 - security message for people keeping production secret_key_base in secrets.yml
      # concern 5 - copy all Rails.application.secrets to ENV
      Rails.application.secrets.each_pair do |key, value|
        ENV[key.to_s] = value
      end
    end

    # concern 3 - rake tasks for set / get
    rake_tasks do
      load "one_secret/tasks.rake"
    end
  end
end if defined?(Rails)
