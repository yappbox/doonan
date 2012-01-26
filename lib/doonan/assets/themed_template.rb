module Doonan
  module Assets
    class ThemedTemplate < Asset
      attr_reader :theme_asset, :template_asset

      def initialize(root, theme_asset, template_asset)
        super(root, "themes/#{theme_asset.name}/#{template_asset.path_without_ext}")
        @theme_asset = add_dependency(theme_asset)
        @template_asset = add_dependency(template_asset)
      end

      def scope
        theme_asset.scope
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
