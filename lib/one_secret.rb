require "one_secret/version"
require "one_secret/key_resolution"
require "one_secret/secret"
require "one_secret/secrets_yaml"
require "encryptor"
require "one_secret/railtie"

module OneSecret
  def self.build(value)
    Secret.new(value)
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
    Secret.load(secret)
  end

  def self.message(text)
    "\e[33m<OneSecret>\e[0m #{text}"
  end
end
