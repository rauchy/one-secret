require './spec/spec_helper'

module OneSecret
  describe Secret do
    describe ".load" do
      it "returns the same value when a non-encrypted hash is provided" do
        Secret.load("hello").must_equal "hello"
      end
    end
  end
end
