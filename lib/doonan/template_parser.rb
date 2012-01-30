module Doonan
  module TemplateParser
    LOADERS = {
      '.erb' => lambda {
        require 'doonan/template_parser/erb'
        Doonan::TemplateParser::ERB.new
      }
    }

    @parsers = {}

    # Get parser key by file type
    def self.key(filename)
      File.extname(filename).downcase
    end

    # Check if template parser available for file type
    #
    # @param [String] used to determine template type
    def self.is_template?(filename)
      LOADERS.key? key(filename)
    end

    # Get parser
    #
    # @param [String] the parser key
    def self.parser(key)
      @parsers[key] ||= LOADERS[key].call()
    end

    # Parse a template
    #
    # @param [String] the path to the file for line numbers and debugging
    # @param [String] the template source
    # @return [Object] an object that responds to parse(fullpath, source)
    #   returning an object that responds to result(binding)
    def self.parse(filename, source)
      parser(key(filename)).parse(filename, source)
    end
  end
end
