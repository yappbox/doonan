require 'multi_json'
require 'doonan/input/hash_asset'

module Doonan
  module Input
    class JsonAsset < HashAsset
      private
      def parse_hash(data)
        MultiJson.decode(data)
      end
    end
  end
end
