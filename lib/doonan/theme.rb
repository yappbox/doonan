require 'doonan/paths'
require 'doonan/assets/scope_input'
require 'doonan/assets/image_input'
require 'doonan/assets/image_output'
require 'doonan/assets/scope_output'
require 'doonan/assets/theme_output'

module Doonan
  class Theme
    attr_reader :config, :path, :theme_outputs, :scope_ouput
    attr_reader :root, :slug, :images_input_root
    attr_reader :scope_input, :scope_output, :image_inputs, :image_outputs, :theme_outputs

    def initialize(pipeline, path)
      @pipeline = pipeline
      @config = pipeline.config
      @path = path
      @root = File.dirname(File.join(config.themes_root, path))
      @slug = File.basename(@root)
      @images_input_root = File.join(@root, 'images')

      @scope_input = build_scope_input

      @image_inputs = {}
      Paths.map(@images_input_root, '**/*.*') do |path|
        @image_inputs[path] = build_image_input(path)
      end
      @image_outputs = {}
      @image_inputs.each_value do |image_input|
        @image_outputs[image_input.path] = build_image_output(image_input)
      end

      @scope_output = build_scope_output

      @theme_outputs = {}
      pipeline.theme_inputs.each_value do |theme_input|
        @theme_outputs[theme_input] = build_theme_output(theme_input)
      end
    end

    def build_scope_input
      Assets::ScopeInput.new(config.themes_root, path)
    end

    def build_scope_output
      Assets::ScopeOutput.new(config.theme_output_root, config.themes_output_prefix, slug, scope_input, image_outputs.values, config.scope_helper)
    end

    def build_image_input(path)
      Assets::ImageInput.new(images_input_root, path)
    end

    def build_image_output(image_input)
      Assets::ImageOutput.new(config.images_output_root, config.themes_output_prefix, slug, image_input)
    end

    def build_theme_output(theme_input)
      Assets::ThemeOutput.new(config.theme_output_root, config.themes_output_prefix, slug, scope_output, theme_input)
    end

    def realize
      @theme_outputs.each_value do |theme_output|
        theme_output.realize
      end
    end
  end
end
