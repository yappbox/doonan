require 'multi_json'
require 'doonan/asset'
require 'doonan/scope'

module Doonan
  module Assets
    class ScopeOutput < Asset
      attr_reader :theme_slug, :scope_input, :image_outputs, :scope_helper, :scope

      def initialize(root, themes_prefix, theme_slug, scope_input, image_outputs, scope_helper)
        super(root, File.join(themes_prefix, theme_slug, 'themes.json'))
        @theme_slug = theme_slug
        @scope_input = add_dependency(scope_input)
        @image_outputs = image_outputs.each {|image_output| add_dependency(image_output) }
        @scope_helper = scope_helper
      end

      def realize_self
        @scope = build_scope
        write MultiJson.encode(@scope)
      end

      def unrealize_self
        @scope = nil
        delete
      end

      private
      def build_scope
        scope = Doonan::Scope.new(scope_input.hash)
        scope.slug = theme_slug
        image_outputs.each do |image_output|
          scope.add_image_info(image_output.slug_path, image_output.image_info)
        end
        scope.resolve_variables
        scope.extend(scope_helper)
        scope
      end
    end
  end
end
