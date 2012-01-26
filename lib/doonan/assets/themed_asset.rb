module Doonan
  module Assets
    class ThemedAsset < Asset
      attr_reader :theme_asset, :source_asset

      def initialize(root, theme_asset, source_asset)
        super(root, "themes/#{theme_asset.name}/#{source_asset.path}")
        @theme_asset = add_dependency(theme_asset)
        @source_asset = add_dependency(source_asset)
      end

      def realize_self
        mkdir_p dir
        cp source_asset.fullpath, fullpath
      end

      def unrealize_self
        delete
      end
    end
  end
end
