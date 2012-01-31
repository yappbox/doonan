require 'doonan/paths'
require 'doonan/assets/theme_input'
require 'doonan/theme'

module Doonan
  class Pipeline
    include ::Doonan::Logging

    attr_reader :config, :theme_inputs, :themes

    def initialize(config, watch=false)
      @config = config
      @theme_inputs = {} # by path
      @themes = {} # by path

      debug("Building theme inputs #{config.theme_input_root} #{config.theme_input_root}")
      Paths.map(config.theme_input_root, config.theme_input_glob) do |path|
        debug(path)
        create_theme_input(path)
      end

      debug("Building themes #{config.themes_root} */*.{yml,json}")
      Paths.map(config.themes_root, '*/*.{yml,json}').map do |path|
        debug(path)
        create_theme(path)
      end
    end

    def realize
      @themes.each_value do |theme|
        theme.realize
      end
    end

    def realize_by_input(path)
      theme_input = @theme_inputs[path]
      theme_input.dependents.each do |theme_output|
        theme_output.realize
      end
    end

    def realize_by_theme(path)
      @themes[path].realize
    end

    def create_theme_input(path)
      theme_input = build_theme_input(path)
      themes.each_value do |theme|
        theme.create_theme_output(theme_input)
      end
      theme_inputs[path] = theme_input
    end

    def update_theme_input(path)
      @theme_inputs[path].unrealize
    end

    def delete_theme_input(path_from_theme_input_root)

    end

    def create_theme(path)
      @themes[path] = Theme.new(self, path)
    end

    def update_theme(path_from_themes_root)
      #find and unrealize scope_input
      #find and realize theme_output dependent on scope_output
    end

    def delete_theme(path_from_themes_root)
      #unrealize scope_input and image_input for this theme
      #remove references from pipeline to assets belonging to this theme
      #remove theme images watcher
    end

    def build_theme_input(path)
      Assets::ThemeInput.new(config.theme_input_root, path)
    end
  end
end
