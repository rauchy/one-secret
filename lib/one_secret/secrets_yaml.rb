require 'yaml'

module OneSecret
  class SecretsYAML
    attr_reader :values

    def initialize(path)
      @path = path
      @values = YAML.load(IO.read(path))
    end

    def set(environment, key, value)
      @values[environment][key] = value
    end

    def save
      File.write(@path, @values.to_yaml)
    end
  end
end
