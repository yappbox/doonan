require 'erb'

module Doonan
  module TemplateParser

    # ERB template parser
    class ERB
      # Parse ERB template
      #
      # @param [String] for debugging and line numbers
      # @param [String] template source
      def parse(filename, source)
        erb = ::ERB.new(source)
        erb.filename = filename
        erb
      end
    end
  end
end
