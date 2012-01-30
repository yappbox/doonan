require 'multi_json'

module Doonan
  module HashParser
    class JSON
      def parse(source)
        ::MultiJson.decode(source)
      end
    end
  end
end
