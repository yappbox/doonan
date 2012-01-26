require 'multi_json'

module Doonan
  module Assets
    class ThemeAsset < Asset
      attr_reader :scope, :scope_asset, :image_assets, :helper_module

      def initialize(root, scope_asset, image_assets, helper_module)
        @scope_asset = source_asset
        @image_assets = image_assets
        @helper_module = helper_module
        dependencies = [source_asset]
        dependencies.concat(image_assets) if image_assets
        path = scope_asset.path_without_ext + '.json'
        super(root, path, dependencies)
      end

      def realize_self
        @scope = build_scope hash_asset.hash
        write MultiJson.encode(@scope)
      end

      private
      def build_scope(hash)
        scope = Doonan::Scope.new(hash)
        scope.resolve_variables
        scope.extend(helper_module)
        scope
      end
    end
  end
end
