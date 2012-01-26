require 'doonan/asset'

module Doonan
  module Assets
    class ThemedImageAsset < Asset
      attr_reader :image_asset, :image_info
      def initialize(root, theme_name, image_asset)
        super(root, "themes/#{theme_name}/#{image_asset.path}") 
        @image_asset = add_dependency(image_asset)
      end

      def realize_self
        mkdir_p dir
        cp image_asset.fullpath, fullpath
        @image_info = build_image_info
      end

      def unrealize_self
        delete
        @image_info = nil
      end

      private
      def build_image_info
        {
          path: path,
          slug: image_asset.slug,
          type: image_asset.type,
          width: image_asset.width,
          height: image_asset.height
        }
      end
    end
  end
end
