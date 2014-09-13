module OneSecret
  class Configuration
    def decrypt_into_env!
      @decrypt_into_env = true
    end

    def decrypt_into_env?
      !!@decrypt_into_env
    end
  end
end
