require 'doonan/asset'

module Doonan
  module Assets
    class ThemeOutput < Asset
      attr_reader :scope_output, :theme_input

      def initialize(root, themes_prefix, theme_slug, scope_output, theme_input)
        @templated = theme_input.is_template?
        if @templated
          path = theme_input.path_without_ext
        else
          path = theme_input.path
        end
        path = File.join(themes_prefix, theme_slug, path)
        super(root, path)
        @scope_output = add_dependency(scope_output)
        @theme_input = add_dependency(theme_input)
      end

      def templated?
        @templated
      end

      private
      def realize_self
        if templated?
          write scope_output.scope.result(theme_input.template)
        else
          mkdir_p dir
          cp theme_input.fullpath, fullpath
        end
      end

      def unrealize_self
        delete
      end
    end
  end
end

