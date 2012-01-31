require 'doonan/asset'

module Doonan
  module Assets
    class ThemeOutput < Asset
      attr_reader :scope_output, :template_input

      def initialize(output_root, scope_output, template_input)
        base_path = File.join('themes', scope_output.theme_slug)
        @templated = template_input.is_template?
        if @templated
          path = File.join(base_path, template_input.path_without_ext)
        else
          path = File.join(base_path, template_input.path)
        end
        super(output_root, path)
        @scope_output = add_dependency(scope_output)
        @template_input = add_dependency(template_input)
      end

      def templated?
        @templated
      end

      private
      def realize_self
        if templated?
          write scope_output.scope.result(template_input.template)
        else
          mkdir_p dir
          cp template_input.fullpath, fullpath
        end
      end

      def unrealize_self
        delete
      end
    end
  end
end

