require 'erb'
require 'tilt'
require 'sass'
require 'compass'

module Doonan
  class Template
    def initialize(template_path)
      @template_path = template_path
      @extension = File.extname(template_path)
      @output_filename = File.basename(template_path).chomp(@extension)
      @template_class = Tilt[@extension]
      if @template_class == Tilt::SassTemplate
        debugger
        @template_class.options[:load_path]
      end
    end
    
    attr_reader :template_path
    attr_reader :output_filename
    
    def render(scope)
      template_source = File.read(@template_path)
      t = @template_class.new { |template| template_source }
      t.render(scope)
    end
  end
end