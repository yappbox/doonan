require 'doonan/input/static_asset'

module Doonan
  module Input
    class HashAsset < StaticAsset
      attr_reader :hash

      def realize_self
        @hash = parse_hash(read)
      end

      def unrealize_self
        @hash = nil
      end

      private
      def parse_hash(data)
        raise NotImplementedError
      end
    end
  end
end
