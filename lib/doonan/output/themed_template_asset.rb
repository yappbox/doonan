require 'doonan/asset'

module Doonan
  module Output
    class ThemedTemplate < Asset
      attr_reader :theme_scope_asset, :template_asset

      def initialize(output_root, theme_scope_asset, template_asset)
        super(output_root, "themes/#{theme_scope_asset.theme_slug}/#{template_asset.path_without_ext}")
        @theme_scope_asset = add_dependency(theme_scope_asset)
        @template_asset = add_dependency(template_asset)
      end

      def scope
        theme_scope_asset.scope
      end

      def template
        template_asset.template
      end

      def realize_self
        write scope.result(template)
      end

      def unrealize_self
        delete
      end
    end
  end
end
