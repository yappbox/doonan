require 'multi_json'

module Doonan
  module Assets
    class JsonAsset < StaticAsset
      attr_reader :hash

      def realize_self
        @hash = MultiJson.decode(read)
      end

      def unrealize_self
        @hash = nil
      end
    end
  end
end
