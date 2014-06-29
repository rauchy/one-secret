require "active_support/core_ext"

module OneSecret
  module KeyResolution
    def self.try(*strategies)
      strategies.each do |strategy|
        klass_name = "OneSecret::#{strategy.to_s.capitalize}KeyResolution"
        klass = klass_name.constantize
        instance = klass.new
        key = instance.key
        return key if key
      end

      raise "OneSecret: Cannot resolve key."
    end
  end
end
