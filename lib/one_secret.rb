require "one_secret/version"
require "one_secret/key_resolution"
require "one_secret/secret"
require "one_secret/secrets_yaml"
require "one_secret/configuration"
require "one_secret/store"
require "encryptor"
require "one_secret/railtie"

module OneSecret
  def self.configure(&block)
    configuration.instance_eval(&block)
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.build(value)
    Secret.unlocked {
      return Secret.new(value)
    }
  end

  def self.set(environment, key, value)
    secrets = SecretsYAML.new(Rails.application.paths["config/secrets"].first)
    build(value).tap do |secret|
      secrets.set(environment, key, secret.to_hash)
      secrets.save
    end
  end

  def self.get(environment, key)
    secrets = SecretsYAML.new(Rails.application.paths["config/secrets"].first)
    secret = secrets.values[environment][key]

    Secret.unlocked {
      return Secret.load(secret)
    }
  end

  def self.get_all(environment)
    secrets = SecretsYAML.new(Rails.application.paths["config/secrets"].first)
    Secret.unlocked {
      return Hash[secrets.values[environment].map { |k, v| [k, Secret.load(v)] }]
    }
  end

  def self.message(text)
    "\e[33m<OneSecret>\e[0m #{text}"
  end
end
