module OneSecret
  class Secret
    def initialize(value)
      @value = value.encrypt
      @iv = SecureRandom.hex(16)
    end

    def to_hash
      {
        value: @value,
        iv: @iv
      }
    end

    def self.load(encrypted_value)
      Encryptor.decrypt(encrypted_value) rescue encrypted_value
    end
  end
end
