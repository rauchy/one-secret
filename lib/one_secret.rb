require "one_secret/version"
require "one_secret/secrets_yaml"
require "encryptor"
require "one_secret/railtie"

module OneSecret
  def self.set(environment, key, value)
    secrets = SecretsYAML.new("config/secrets.yml")
    secrets.set(Rails.env, key, value.encrypt)
    secrets.save
  end

  def self.get(environment, key)
    secrets = SecretsYAML.new("config/secrets.yml")
    secrets.values[Rails.env][key].decrypt
  end
end
