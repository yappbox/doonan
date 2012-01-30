require 'hashie'
require 'multi_json'
require 'doonan/scope/image_info'

module Doonan
  class Scope < ::Hashie::Mash
    class Images
      include ::Enumerable

      def initialize
        @hash = {}
        @image_infos = []
      end

      def add_images(slug)
        slug = slug.to_sym
        return @hash[slug] if @hash.key? slug
        images = Images.new
        @hash[slug] = images
        class << self; self; end.class_eval do
          define_method(slug) { images }
        end
        images
      end

      def get_path(slug_path)
        slug_path.inject(self) {|images, slug| images.add_images(slug) }
      end

      def add_image_info(image_info)
        slug = image_info.slug.to_sym
        @hash[slug] = image_info
        @image_infos << image_info
        class << self; self; end.class_eval do
          define_method(slug) { image_info }
        end
        image_info
      end

      def method_missing(method_name, *args, &blk)
        if /(.*)\?$/ =~ method_name.to_s
          return @hash.key?($1.to_sym)
        end
        super(method_name, *args, &blk)
      end

      def each(&block)
        @image_infos.each(&block)
      end

      def as_json(*args)
        @hash
      end

      def to_json(*args)
        ::MultiJson.encode(as_json)
      end
    end
  end
end
