require "one_secret/version"
require "one_secret/secret"
require "one_secret/secrets_yaml"
require "encryptor"
require "one_secret/railtie"

module OneSecret
  def self.set(environment, key, value)
    secrets = SecretsYAML.new("config/secrets.yml")
    secret = Secret.new(value)
    secrets.set(Rails.env, key, secret.to_hash)
    secrets.save
  end

  def self.get(environment, key)
    secrets = SecretsYAML.new("config/secrets.yml")
    secret = secrets.values[Rails.env][key]
    Secret.load(secret)
  end
end
