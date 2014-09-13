module OneSecret
  class Railtie < Rails::Railtie
    config.before_initialize do
      if should_run?
        Secret.unlocked do
          each_secret do |name, secret|
            put_in_stores(name, secret)
          end
        end
      end
    end

    rake_tasks do
      load "one_secret/tasks.rake"
    end

    private

    class << self

      def each_secret(&block)
        Rails.application.secrets.each_pair(&block)
      end

      def put_in_stores(name, secret)
        [ApplicationSecretsStore, EnvStore].each { |s| s.new.put(name, secret) }
      end

      def should_run?
        if defined?(Rake)
          !Rake.application.top_level_tasks.include?("assets:precompile")
        else
          true
        end
      end
    end
  end
end if defined?(Rails)
