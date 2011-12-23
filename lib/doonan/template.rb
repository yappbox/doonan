require 'erb'
require 'tilt'
require 'sass'
require 'compass'

module Doonan
  class Template
    def initialize(template_path, load_paths)
      @template_path = template_path
      extension = File.extname(template_path)
      @output_filename = File.basename(template_path).chomp(extension)
      template_class = Tilt[extension]
      options = {}
      if template_class <= Tilt::SassTemplate
        load_paths += Compass.sass_engine_options[:load_paths]
        options[:load_paths] = load_paths
        options[:style] = :expanded
        options[:line_comments] = true
      end
      @template = template_class.new(template_path, 1, options)
    end

    attr_reader :template_path
    attr_reader :output_filename

    def render(scope)
      @template.render(scope)
    end
  end
end
