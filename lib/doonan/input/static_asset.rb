require 'doonan/asset'

module Doonan
  module Input
    # Static asset represents an existing file
    class StaticAsset < Asset
      private
      def realize_self
      end

      def unrealize_self
      end

      def add_dependency
        raise NotImplementedError, 'static assets represent an existing file'
      end

      def write
        raise NotImplementedError, 'static assets are readonly'
      end

      def delete
        raise NotImplementedError, 'static assets are readonly'
      end
    end
  end
end
