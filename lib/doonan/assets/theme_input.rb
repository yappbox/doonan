require 'doonan/assets/static_asset'
require 'doonan/template_parser'

module Doonan
  module Assets
    # Theme input asset
    #
    # If theme asset is a template that can be evaled with a scope,
    # #realize will parse it. If not, the file will just be copied to
    # the theme output.
    class ThemeInput < StaticAsset
      ParseError = Class.new(StandardError)
      attr_reader :template

      def is_template?
        @is_template ||= TemplateParser.is_template?(path)
      end

      def realize_self
        @template = parse_template if is_template?
      end

      def unrealize_self
        @template = nil
      end

      private
      def parse_template
        TemplateParser.parse(fullpath, read)
      rescue
        raise ParseError.new("Failed to parse #{fullpath}: #{$!}")
      end
    end
  end
end
