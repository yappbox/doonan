require 'erb'
require 'tilt'
require 'sass'

module Doonan
  class Template
    def initialize(template_path)
      @template_path = template_path
      filename_parts = File.basename(template_path).split('.')
      @output_filename = filename_parts.slice(0...2).join('.')
      @extensions_to_process = filename_parts.slice(2..-1).reverse
    end

    attr_reader :output_filename
    
    def render(scope)
      @extensions_to_process.inject(File.read(@template_path)) do |output, extension|
        template = Tilt[extension].new { |template| output }
        template.render(scope)
      end
    end
  end
end