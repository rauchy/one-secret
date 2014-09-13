require './spec/spec_helper'

module OneSecret
  describe ApplicationSecretsStore do
    describe "#put" do
      it "puts values in Rails.application.secrets" do
        ::Rails = double
        ::Rails.stub_chain(:application, :secrets).and_return(OpenStruct.new)

        ApplicationSecretsStore.new.put(:foo, "bar")
        Rails.application.secrets.foo.must_equal "bar"
      end
    end
  end

  describe EnvStore do
    describe "#put" do
      it "puts values in ENV when configured to do so" do
        OneSecret.configure { decrypt_into_env! }
        EnvStore.new.put(:foo, "bar")
        ENV["foo"].must_equal "bar"
      end

      it "doesn't put values in ENV when not configured to do so" do
        OneSecret.configure { decrypt_into_env!(false) }
        EnvStore.new.put(:baz, "qux")
        ENV["baz"].must_be_nil
      end
    end
  end
end
