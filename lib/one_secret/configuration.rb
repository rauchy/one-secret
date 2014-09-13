module OneSecret
  class Configuration
    def decrypt_into_env!(should_decrypt=true)
      @decrypt_into_env = should_decrypt
    end

    def decrypt_into_env?
      !!@decrypt_into_env
    end
  end
end
