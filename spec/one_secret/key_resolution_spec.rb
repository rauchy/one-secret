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
  end
end
