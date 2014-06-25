module OneSecret
  class Secret
    def initialize(value)
      @value = value.encrypt
    end

    def to_hash
      { value: @value }
    end

    def self.load(encrypted_value)
      Encryptor.decrypt(encrypted_value) rescue encrypted_value
    end
  end
end
