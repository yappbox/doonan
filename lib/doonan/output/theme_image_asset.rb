require 'doonan/asset'

module Doonan
  module Output
    class ThemeImageAsset < Asset
      attr_reader :image_asset, :image_info
      def initialize(images_root, theme_slug, image_asset)
        super(images_root, "themes/#{theme_slug}/#{image_asset.path}")
        @image_asset = add_dependency(image_asset)
      end

      def slug
        image_asset.slug
      end

      def slug_path
        image_asset.slug_path
      end

      private
      def realize_self
        mkdir_p dir
        cp image_asset.fullpath, fullpath
        @image_info = build_image_info
      end

      def unrealize_self
        delete
        @image_info = nil
      end

      def build_image_info
        {
          :path => path,
          :slug => image_asset.slug,
          :type => image_asset.type,
          :width => image_asset.width,
          :height => image_asset.height
        }
      end
    end
  end
end
