require 'doonan/input/static_asset'

module Doonan
  module Input
    # Static template file
    class TemplateAsset < StaticAsset
      attr_reader :template, :template_builder

      def initialize(input_root, path, template_builder)
        super(input_root, path)
        @template_builder = template_builder
      end

      def realize_self
        @template = template_builder.build(fullpath, read)
      end

      def unrealize_self
        @template = nil
      end
    end
  end
end
