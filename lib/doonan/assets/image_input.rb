require 'image_size'
require 'doonan/assets/static_asset'

module Doonan
  module Assets
    class ImageInput < StaticAsset
      attr_reader :format, :width, :height

      def realize_self
        read do |io|
          # reads head to determine image type and size
          image_size = ImageSize.new(io)
          @format = image_size.format
          @width = image_size.width
          @height = image_size.height
        end
      end

      def unrealize_self
        @format = @width = @height = nil
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
