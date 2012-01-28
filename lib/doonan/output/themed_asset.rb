require 'doonan/asset'

module Doonan
  module Output
    class ThemedAsset < Asset
      attr_reader :theme_scope_asset, :input_asset

      def initialize(output_root, theme_scope_asset, input_asset)
        super(output_root, "themes/#{theme_scope_asset.theme_slug}/#{input_asset.path}")
        @theme_scope_asset = add_dependency(theme_scope_asset)
        @input_asset = add_dependency(input_asset)
      end

      private
      def realize_self
        mkdir_p dir
        cp input_asset.fullpath, fullpath
      end

      def unrealize_self
        delete
      end
    end
  end
end
