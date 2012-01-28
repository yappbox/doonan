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

      def build(filename, source)
        erb = ::ERB.new(source)
        erb.filename = filename
        erb
      end
    end
  end
end
