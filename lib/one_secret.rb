require "one_secret/version"
require "one_secret/secrets_yaml"
require "one_secret/railtie"

module OneSecret
  def self.set(environment, key, value)
    secrets = SecretsYAML.new("config/secrets.yml")
    secrets.set(Rails.env, key, value)
    secrets.save
  end
end
