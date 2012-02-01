require 'hashie'
require 'multi_json'

module Doonan
  class Scope < ::Hashie::Mash
    ImageInfo = ::Struct.new(:path, :slug, :format, :width, :height) do
      def as_json(*args)
        members.inject({}) {|hash,member| hash[member] = self[member]; hash}
      end

      def key?(key)
        members.include? key.to_sym
      end

      def [](key)
        super(key.to_sym)
      end

      def to_json(*args)
        ::MultiJson.encode(as_json)
      end
    end
  end
end
