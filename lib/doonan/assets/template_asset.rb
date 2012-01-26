require 'erb'

module Doonan
  module Assets
    # Static template file
    class TemplateAsset < StaticAsset
      attr_reader :template

      def realize_self
        @template = build_template(read)
      end

      def unrealize_self
        @template = nil
      end

      private
      def build_template(source)
        ERB.new(source)
      end
    end
  end
end
