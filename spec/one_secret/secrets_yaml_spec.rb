require './spec/spec_helper'
require 'tempfile'

module OneSecret
  describe SecretsYAML do
    def temp_file(content)
      file = Tempfile.new('foo')
      file.write(content)
      file.flush
      file.path
    end
    
    it "keeps comments" do
      path = temp_file("# Please keep me")

      SecretsYAML.new(path).save

      File.readlines(path).must_equal ["# Please keep me"]
    end
  end
end
