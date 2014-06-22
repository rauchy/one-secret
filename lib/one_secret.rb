require "one_secret/version"
require "one_secret/secrets_yaml"
require "encryptor"
require "one_secret/railtie"

module OneSecret
  default_options = {:key => "some_key"}
  Encryptor.default_options.merge!(default_options)

  def self.set(environment, key, value)
    secrets = SecretsYAML.new("config/secrets.yml")
    secrets.set(Rails.env, key, value.encrypt)
    secrets.save
  end
end
