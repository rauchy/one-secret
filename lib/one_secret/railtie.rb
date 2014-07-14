module OneSecret
  class Railtie < Rails::Railtie
    config.before_initialize do
      Secret.key = KeyResolution.try(:env, :rails, :stdin)

      Rails.application.secrets.each_pair do |key, value|
        Rails.application.secrets[key] = ENV[key.to_s] = Secret.load(value)
      end

      # concern 4 - security message for people keeping production secret_key_base in secrets.yml
    end

    rake_tasks do
      load "one_secret/tasks.rake"
    end
  end
end if defined?(Rails)
