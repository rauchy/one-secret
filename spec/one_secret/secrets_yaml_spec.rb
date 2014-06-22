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
    
    it "sets a new value" do
      path = temp_file """---

development:

  foo: bar
"""
      secrets = SecretsYAML.new(path)
      secrets.set("development", "foo", "baz")
      secrets.save

      File.readlines(path).join("\n").must_equal """---

development:

  foo: baz
"""
    end
  end
end
