require 'doonan/asset'

module Doonan
  module Assets
    # Static asset represents an existing file
    # #exist? should start out as true before #realize
    # #realize processes the static file
    class StaticAsset < Asset
      private
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
