require './spec/spec_helper'

module OneSecret
  describe Secret do
    def with_iv(iv)
      SecureRandom.stub(:hex, iv) { yield }
    end

    def with_salt(salt)
      Time.stub(:now, salt) { yield }
    end

    before do
      Encryptor.default_options.merge!(key: "f3bbdba9485ac1ee1412d2c839be0a0f")
    end

    it "encrypts a string" do
      with_iv "I am a random iv" do
        with_salt Time.at(0) do
          secret = Secret.new("Encrypt me!")
          secret.to_hash.keys.must_include :value
          secret.to_hash[:value].must_be :!=, "Encrypt me!"
        end
      end
    end

    it "uses a random iv" do
      with_iv "I am a random iv" do
        secret = Secret.new("Encrypt me!")
        secret.to_hash.keys.must_include :iv
        secret.to_hash[:iv].must_be :==, "I am a random iv"
      end
    end

    it "uses now as a salt" do
      with_salt Time.at(0) do
        secret = Secret.new("Encrypt me!")
        secret.to_hash.keys.must_include :salt
        secret.to_hash[:salt].must_be :==, "0"
      end
    end

    it "specifies the algorithm being used" do
      secret = Secret.new("Encrypt me!")
      secret.to_hash.keys.must_include :algorithm
      secret.to_hash[:algorithm].must_equal "aes-256-cbc"
    end

    describe ".load" do
      it "returns the same value when a non-encrypted hash is provided" do
        Secret.load("I am not encrypted").must_equal "I am not encrypted"
      end

      it "decrypts encrypted hashes" do
        encrypted_hash = {
          value: "\xE6N\x9DF\xDA%\xC2nR\n\x1D\x9F\xE0l\xB1\x1F",
          iv: "b511f7ffa666467c1c55f466886277b8",
          salt: "12be65aafdd78c0540146f2f995c95c7",
          algorithm: "aes-256-cbc"
        }

        Secret.load(encrypted_hash).must_equal "I am encrypted"
      end
    end
  end
end
