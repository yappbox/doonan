require 'erb'
require 'tilt'
require 'sass'
require 'compass'

module Doonan
  class Template
    def initialize(template_path)
      @template_path = template_path
      filename_parts = File.basename(template_path).split('.')
      @output_filename = filename_parts.slice(0...2).join('.')
      @extensions_to_process = filename_parts.slice(2..-1).reverse
    end
    
    attr_reader :template_path
    attr_reader :output_filename
    
    def render(scope)
      debugger
      template_source = File.read(@template_path)
      t = Tilt[@extensions_to_process.first].new { |template| template_source }
      t.render(scope)
    end
  end
end