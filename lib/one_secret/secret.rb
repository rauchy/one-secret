module OneSecret
  class Secret
    class << self
      def unlocked
        self.key = KeyResolution.try(:env, :rails, :stdin)
        yield
        self.key = nil
      end

      def key=(key)
        Encryptor.default_options.merge!({key: key})
      end
    end

    def initialize(value)
      @iv = SecureRandom.hex(16)
      @salt = Time.now.to_i.to_s
      @value = Encryptor.encrypt(to_hash.merge(value: value))
    end

    def to_hash
      {
        value: @value,
        iv: @iv,
        salt: @salt,
        algorithm: Encryptor.default_options[:algorithm]
      }
    end

    def self.load(encrypted_value)
      Encryptor.decrypt(encrypted_value) rescue encrypted_value
    end
  end
end
