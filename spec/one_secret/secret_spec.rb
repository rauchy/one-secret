require './spec/spec_helper'

module OneSecret
  describe Secret do
    before do
      Encryptor.default_options.merge!(key: "f3bbdba9485ac1ee1412d2c839be0a0f")
    end

    it "encrypts a string" do
      secret = Secret.new("Encrypt me!")
      secret.to_hash.keys.must_include :value
      secret.to_hash[:value].must_be :!=, "Encrypt me!"
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
