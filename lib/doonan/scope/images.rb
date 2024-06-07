require 'hashie'
require 'multi_json'
require 'doonan/scope/image_info'

module Doonan
  class Scope < ::Hashie::Mash
    class Images
      include ::Enumerable

      def initialize
        @hash = ::Hashie::Mash.new
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
        slug_path.inject(self) { |images, slug| images.add_images(slug) }
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

      def key?(key)
        @hash.key?(key)
      end

      def [](key)
        @hash[key]
      end

      def respond_to?(method_name, include_private=false)
        @hash.respond_to?(method_name, include_private) || super(method_name, include_private)
      end

      def method_missing(method_name, *args, &blk)
        @hash.send(method_name, *args, &blk)
      end

      def respond_to_missing?(method_name, *args, &blk)
        @hash.respond_to?(method_name, *args, &blk)
      end

      def each(&block)
        @image_infos.each(&block)
      end

      def as_json(*_args)
        @hash
      end

      def to_json(*_args)
        ::MultiJson.encode(as_json)
      end
    end
  end
end
