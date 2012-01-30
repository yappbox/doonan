require 'multi_json'
require 'doonan/asset'
require 'doonan/scope'

module Doonan
  module Output
    class ThemeScopeAsset < Asset
      attr_reader :theme_slug, :scope_hash_asset, :theme_image_assets, :scope_helper, :scope

      def initialize(output_root, theme_slug, scope_hash_asset, theme_image_assets, scope_helper)
        super(output_root, "themes/#{theme_slug}/theme.json")
        @theme_slug = theme_slug
        @scope_hash_asset = add_dependency(scope_hash_asset)
        @theme_image_assets = theme_image_assets.each {|image_asset| add_dependency(image_asset) }
        @scope_helper = scope_helper
      end

      def realize_self
        @scope = build_scope scope_hash_asset.hash
        write MultiJson.encode(@scope)
      end

      def unrealize_self
        @scope = nil
        delete
      end

      private
      def build_scope(hash)
        scope = Doonan::Scope.new(hash)
        scope.theme_slug = theme_slug
        scope.resolve_variables
        scope.extend(scope_helper)
        theme_image_assets.each do |image_asset|
          scope.add_image_info(image_asset.slug_path, image_asset.image_info)
        end
        scope
      end
    end
  end
end
