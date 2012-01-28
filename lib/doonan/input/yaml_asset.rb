require 'yaml'
require 'doonan/input/hash_asset'

module Doonan
  module Input
    class YamlAsset < HashAsset
      private
      def parse_hash(data)
        YAML.load(data)
      end
    end
  end
end
