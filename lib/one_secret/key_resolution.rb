require "active_support/core_ext"

module OneSecret
  module KeyResolution
    def self.try(*strategies)
      strategies.each do |strategy|
        klass_name = "OneSecret::KeyResolution::#{strategy.to_s.capitalize}"
        klass = klass_name.constantize
        instance = klass.new
        key = instance.key
        return key if key
      end

      raise "OneSecret: Cannot resolve key."
    end

    class Env
      def initialize(env = ENV)
        @env = env
      end

      def key
        @env["secret_key_base"] || @env["SECRET_KEY_BASE"]
      end
    end

    class Rails
      def key
        ::Rails.application.secrets.secret_key_base
      end
    end

    class Stdin
      require 'io/console'

      def initialize(output = STDOUT, input = STDIN)
        @output = output
        @input = input
      end

      def key
        @output.print "<OneSecret> Please enter your secret key: "
        key = @input.noecho(&:gets).chomp
        @output.puts
        key unless key.blank?
      end
    end
  end
end
