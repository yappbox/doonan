require 'yaml'

module Doonan
  module HashParser
    class YAML
      def parse(source)
        ::YAML.load(source)
      end
    end
  end
end
