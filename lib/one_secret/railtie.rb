module OneSecret
  class Railtie < Rails::Railtie
    config.before_initialize do
      if should_run?
        Secret.key = KeyResolution.try(:env, :rails, :stdin)

        Rails.application.secrets.each_pair do |key, value|
          Rails.application.secrets[key] = ENV[key.to_s] = Secret.load(value)
        end
      end
    end

    rake_tasks do
      load "one_secret/tasks.rake"
    end

    private

    def self.should_run?
      if defined?(Rake)
        !Rake.application.top_level_tasks.include?("assets:precompile")
      else
        true
      end
    end
  end
end if defined?(Rails)
