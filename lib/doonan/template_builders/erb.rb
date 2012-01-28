require 'erb'

module Doonan
  # A TemplateBuilder must implement
  # #is_template?(path)
  # #build(template_source) => instance with #result(binding)
  #
  # #build should return an instance that responds to #result(binding)
  module TemplateBuilder

    # ERB template builder
    class Erb
      ERB_EXT = /.erb$/i

      def is_template?(path)
        ERB_EXT =~ path
      end

      def build(source)
        ::ERB.new(source)
      end
    end
  end
end
