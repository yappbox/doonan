require 'doonan/asset'

module Doonan
  module Output
    class ThemedAsset < Asset
      attr_reader :theme_scope_asset, :input_asset

      def initialize(output_root, theme_scope_asset, input_asset)
        base_path = File.join('themes', theme_scope_asset.theme_slug)
        @templated = input_asset.respond_to? :template
        if @templated
          path = File.join(base_path, input_asset.path_without_ext)
        else
          path = File.join(base_path, input_asset.path)
        end
        super(output_root, path)
        @theme_scope_asset = add_dependency(theme_scope_asset)
        @input_asset = add_dependency(input_asset)
      end

      def scope
        theme_scope_asset.scope
      end

      def templated?
        @templated
      end

      private
      def realize_self
        if templated?
          write scope.result(input_asset.template)
        else
          mkdir_p dir
          cp input_asset.fullpath, fullpath
        end
      end

      def unrealize_self
        delete
      end
    end
  end
end
