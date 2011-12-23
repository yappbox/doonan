require 'erb'
require 'tilt'
require 'sass'
require 'compass'

module Doonan
  class Template
    def initialize(template_path, load_paths)
      @template_path = template_path
      @load_paths = load_paths
      @extension = File.extname(template_path)
      @output_filename = template_path.chomp(@extension)
    end

    attr_reader :template_path
    attr_reader :output_filename

    def render(scope)
      template.render(scope)
    end
    
  private
    
    def template
      @template ||= begin
        template_class = Tilt[@extension]
        template_class.new(@template_path, 1, template_options(template_class))
      end
    end
    
    def template_options(template_class)
      options = {}
      options.merge!(sass_options) if template_class <= Tilt::SassTemplate
      options
    end
  
    def sass_options
      {
        load_paths: @load_paths + Compass.sass_engine_options[:load_paths],
        style: :expanded,
        line_comments: true
      }
    end
  end
end
