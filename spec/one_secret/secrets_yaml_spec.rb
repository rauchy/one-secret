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
    
    it "sets new values in the correct environment" do
      path = temp_file """---

development:

  foo: bar

test:

  bar: baz

production:

  baz: qux
"""
      secrets = SecretsYAML.new(path)
      secrets.set("test", "bar", "barness")
      secrets.save

      File.readlines(path).join("\n").must_equal """---

development:

  foo: bar

test:

  bar: barness

production:

  baz: qux
"""

    end
  end
end
