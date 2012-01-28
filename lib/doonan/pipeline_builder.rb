require 'doonan/paths'
require 'doonan/assets'
require 'doonan/pipeline'

module Doonan
  class PipelineBuilder
    attr_accessor :input_root, :input_glob, :output_root, :themes_root, :images_root

    def initialize
      @input_root = 'templates'
      @input_glob = '**/*'
      @themes_root = 'themes'
      @output_root = 'sass'
      @images_root = 'images'
      @scope_helper = Module.new
    end

    def scope_helpers(*modules)
      @scope_helper.instance_eval do
        include *modules
      end
    end

    def build_pipeline
    end

    def build_inputs
      map_paths(input_root, input_glob) do |path|
        build_input(input_root, path)
      end
    end

    def build_input_asset(input_root, path)
      if template_builder.is_template? path
        build_input_template_asset(input_root, path, template_builder)
      else
        build_input_static_asset(input_root, path)
      end
    end

    def build_themes
      map_paths(themes_root, '*/*.{yml,json}').map do |path|
        build_theme(themes_root, path)
      end
    end

    def build_theme(themes_root, theme_path)
      theme_slug = theme_slug(theme_path)
      theme_images_root = theme_images_root(theme_path)
      theme_image_assets = input_image_assets(theme_images_root)
      themed_image_assets = build_themed_image_assets(images_root, theme_slug, theme_image_assets)
      hash_asset = build_hash_asset(root, path)
      build_theme_asset(output_root, theme_name, hash_asset, themed_image_assets, scope_helper)
    end

    def theme_slug(theme_path)
      File.basename(File.dirname(theme_path))
    end

    def theme_images_root(theme_path)
      File.join(File.dirname(theme_path), 'images')
    end

    def build_outputs(inputs, themes)
    end

    def build_output(input, theme)
    end

    def template_builder
      @template_builder ||= begin
        require 'doonan/template_builders/erb'
        TemplateBuilders::Erb.new
      end
    end

    def map_paths(root, glob, &block)
      Paths.new(File.expand_path(root), glob).map(&block)
    end


    ### Asset factories

    def input_static_asset(input_root, path)
      Input::StaticAsset.new(input_root, path)
    end

    def input_template_asset(input_root, path, template_builder)
      Input::TemplateAsset.new(input_root, path, template_builder)
    end

    def input_hash_asset(themes_root, path)
      ext = File.extname(path)
      case ext
      when '.json'
        build_input_json_asset(themes_root, path)
      when '.yml'
        build_input_yaml_asset(themes_root, path)
      else
        raise "unsupported hash format #{ext}"
      end
    end

    def input_json_asset(themes_root, path)
      Input::JsonAsset.new(themes_root, path)
    end

    def input_yaml_asset(themes_root, path)
      Input::YamlAsset.new(themes_root, path)
    end

    def input_image_asset(theme_images_root, path)
      Input::ImageAsset.new(theme_images_root, path)
    end

    def output_theme_image_asset(images_root, theme_slug, image_asset)
      Output::ThemeImageAsset.new(images_root, theme_slug, image_asset)
    end

    def output_theme_scope_asset(output_root, theme_slug, scope_hash_asset, theme_image_assets, scope_helper)
      Output::ThemeScopeAsset.new(output_root, theme_slug, scope_hash_asset, theme_image_assets, scope_helper)
    end

    def output_themed_asset(output_root, theme_scope_asset, input_asset)
      Output::ThemedAsset.new(output_root, theme_scope_asset, input_asset)
    end

    def output_themed_template_asset(output_root, theme_scope_asset, input_asset)
      Output::ThemedTemplateAsset.new(output_root, theme_scope_asset, input_asset)
    end
  end
end
