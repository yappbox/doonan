require 'doonan/asset'
require 'doonan/scope/image_info'

module Doonan
  module Assets
    class ImageOutput < Asset
      attr_reader :image_input, :image_info

      def initialize(root, themes_prefix, theme_slug, image_input)
        super(root, File.join(themes_prefix, theme_slug, image_input.path))
        @image_input = add_dependency(image_input)
      end

      def slug_path
        image_input.slug_path
      end

      private
      def realize_self
        mkdir_p dir
        cp image_input.fullpath, fullpath
        @image_info = build_image_info
      end

      def unrealize_self
        delete
        @image_info = nil
      end

      def build_image_info
        Scope::ImageInfo.new(path, image_input.slug, image_input.format, image_input.width, image_input.height)
      end
    end
  end
end
