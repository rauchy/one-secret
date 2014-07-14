module OneSecret
  class Railtie < Rails::Railtie
    config.before_initialize do
      Secret.key = KeyResolution.try(:env, :rails, :stdin)

      Rails.application.secrets.each_pair do |key, value|
        Rails.application.secrets[key] = ENV[key.to_s] = Secret.load(value)
      end
    end

    rake_tasks do
      load "one_secret/tasks.rake"
    end
  end
end if defined?(Rails)
