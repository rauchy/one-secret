require './spec/spec_helper'

module OneSecret
  describe KeyResolution do
    it "instantiates strategies" do
      KeyResolution::Foo = double("FooKeyResolution")
      expect(KeyResolution::Foo).to receive(:new).and_return(double(key: true))
      KeyResolution.try(:foo)
    end

    it "uses strategies" do
      KeyResolution::Bar = double(new: double(key: 5))
      KeyResolution.try(:bar).must_equal 5
    end

    it "tries all strategies until some key is returned" do
      KeyResolution::Bar = double(new: double(key: nil))
      KeyResolution::Baz = double(new: double(key: 5))
      KeyResolution::Qux = double(new: double(key: 6))

      KeyResolution.try(:bar, :baz, :qux).must_equal 5
    end

    it "raises an error if no key was found using all strategies" do
      KeyResolution::Bar = double(new: double(key: nil))
      -> { KeyResolution.try(:bar) }.must_raise RuntimeError
    end

    describe KeyResolution::Env do
      it "resolves a key using an environment variable called 'secret_key_base'" do
        KeyResolution::Env.new({"secret_key_base" => "hola"}).key.must_equal "hola"
      end

      it "resolves a key using an environment variable called 'SECRET_KEY_BASE'" do
        KeyResolution::Env.new({"SECRET_KEY_BASE" => "amigo"}).key.must_equal "amigo"
      end

      it "fails to resolve a key otherwise" do
        KeyResolution::Env.new({}).key.must_be_nil
      end
    end

    describe KeyResolution::Rails do
      it "resolves a key using Rails' application secrets" do
        ::Rails = double
        ::Rails.stub_chain(:application, :secrets, :secret_key_base).and_return("hola")
        KeyResolution::Rails.new.key.must_equal "hola"
      end

      it "fails to resolve a key otherwise" do
        ::Rails = double
        ::Rails.stub_chain(:application, :secrets, :secret_key_base)
        KeyResolution::Rails.new.key.must_be_nil
      end
    end
  end
end
