class SecretConfigGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  argument :key, type: :string
  argument :value, type: :string

  def secret_config
    OneSecret.set(Rails.env, key, value)
  end
end
