require 'yaml'

module Doonan
  module Assets
    class YamlAsset < StaticAsset
      attr_reader :hash

      def realize_self
        @hash = YAML.load_file(fullpath)
      end

      def unrealize_self
        @hash = nil
      end
    end
  end
end
