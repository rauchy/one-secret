module OneSecret
  class Store
    def initialize(hash)
      @hash = hash
    end

    def put(key, value)
      decrypted_value = Secret.load(value)
      @hash[key.to_s] = decrypted_value
    end
  end

  class ApplicationSecretsStore < Store
    def initialize
      super(Rails.application.secrets)
    end
  end

  class EnvStore < Store
    def initialize
      @decrypt_into_env = OneSecret.configuration.decrypt_into_env?
      super(ENV)
    end

    def put(key, value)
      super(key, value) if @decrypt_into_env
    end
  end
end
