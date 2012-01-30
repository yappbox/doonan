require 'doonan/assets/static_asset'
require 'doonan/hash_parser'

module Doonan
  module Assets
    class ScopeInput < StaticAsset
      attr_reader :hash

      def realize_self
        @hash = parse_hash
      end

      def unrealize_self
        @hash = nil
      end

      private
      def parse_hash
        HashParser.parse(path, read)
      end
    end
  end
end
