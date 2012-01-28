require 'image_size'
require 'doonan/input/static_asset'

module Doonan
  module Input
    class ImageAsset < StaticAsset
      attr_reader :type, :width, :height

      def realize_self
        read do |io|
          # reads head to determine image type and size
          image_size = ImageSize.new(io)
          @type = image_size.format
          @width = image_size.width
          @height = image_size.height
        end
      end

      def unrealize_self
        @type = @width = @height = nil
      end

      def slug
        @slug ||= File.basename(path_without_ext)
      end

      def slug_path
        @slug_path ||= begin
          slug_path = path.split('/')
          slug_path.pop()
          slug_path
        end
      end
    end
  end
end
