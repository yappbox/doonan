require 'doonan/paths'
require 'doonan/input/static_asset'
require 'doonan/input/template_asset'
require 'doonan/output/themed_asset'
require 'doonan/theme_builder'
require 'doonan/pipeline'

module Doonan
  class PipelineBuilder
    attr_accessor :input_root, :input_glob, :output_root, :themes_root, :images_root, :scope_helper

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

    def build_input_assets
      Paths.map(input_root, input_glob) do |path|
        build_input_asset(path)
      end
    end

    def build_input_asset(path)
      if template_builder.is_template? path
        build_template_asset(path)
      else
        build_static_asset(path)
      end
    end

    def build_theme_builders
      Paths.map(themes_root, '*/*.{yml,json}').map do |theme_path|
        build_theme_builder(theme_path)
      end
    end

    def build_theme_builder(theme_path)
      ThemeBuilder.new(
        File.expand_path(themes_root),
        File.expand_path(images_root),
        File.expand_path(output_root),
        theme_path, scope_helper
      )
    end

    def build_theme_scope_assets
      build_theme_builders.map do |theme_builder|
        build_theme_scope_asset(theme_builder)
      end
    end

    def build_theme_scope_asset(theme_builder)
      scope_hash_asset = theme_builder.build_scope_hash_asset
      image_assets = theme_builder.build_image_assets
      theme_image_assets = theme_builder.build_theme_image_assets image_assets
      theme_builder.build_theme_scope_asset scope_hash_asset, theme_image_assets
    end

    def build_themed_assets(input_assets, *theme_scope_assets)
      if theme_scope_assets.size == 1 && Array === theme_scope_assets[0]
        theme_scope_assets = theme_scope_assets[0]
      end
      themed_assets = []
      input_assets.each do |input_asset|
        theme_scope_assets.each do |theme_scope_asset|
          themed_assets << build_themed_asset(theme_scope_asset, input_asset)
        end
      end
      themed_assets
    end

    def template_builder
      @template_builder ||= begin
        require 'doonan/template_builder/erb'
        TemplateBuilder::Erb.new
      end
    end

    def build_static_asset(path)
      Input::StaticAsset.new(input_root, path)
    end

    def build_template_asset(path)
      Input::TemplateAsset.new(input_root, path, template_builder)
    end

    def build_themed_asset(theme_scope_asset, input_asset)
      Output::ThemedAsset.new(output_root, theme_scope_asset, input_asset)
    end
  end
end