require 'doonan/assets/static_asset'
require 'doonan/hash_parser'

module Doonan
  module Assets
    class ScopeInput < StaticAsset
      ParseError = Class.new(StandardError)
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
      rescue
        raise ParseError.new("Failed to parse #{fullpath}: #{$!}")
      end
    end
  end
end
