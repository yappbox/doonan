require 'doonan/input/json_asset'
require 'doonan/input/yaml_asset'
require 'doonan/input/image_asset'
require 'doonan/output/theme_image_asset'
require 'doonan/output/theme_scope_asset'

module Doonan
  class ThemeBuilder
    attr_reader :themes_root, :images_root, :output_root, :theme_path, :scope_helper
    attr_reader :theme_root, :theme_slug, :theme_images_root

    def initialize(themes_root, images_root, output_root, theme_path, scope_helper)
      @themes_root = themes_root
      @images_root = images_root
      @output_root = output_root
      @scope_helper = scope_helper

      @theme_path = theme_path
      @theme_root = File.dirname(File.join(themes_root, theme_path))
      @theme_slug = File.basename(@theme_root)
      @theme_images_root = File.join(@theme_root, 'images')
    end

    def build_scope_hash_asset
      ext = File.extname(theme_path)
      case ext
      when '.json'
        build_input_json_asset
      when '.yml'
        build_input_yaml_asset
      else
        raise "unsupported hash format #{ext}"
      end
    end

    def build_image_assets
      Paths.map(theme_images_root, '**/*.{png,jpg}') do |path|
        build_image_asset(path)
      end
    end

    def build_theme_image_assets(image_assets)
      image_assets.map do |image_asset|
        build_theme_image_asset(image_asset)
      end
    end

    def build_json_asset
      Input::JsonAsset.new(themes_root, theme_path)
    end

    def build_yaml_asset
      Input::YamlAsset.new(themes_root, theme_path)
    end

    def build_image_asset(path)
      Input::ImageAsset.new(theme_images_root, path)
    end

    def build_theme_image_asset(image_asset)
      Output::ThemeImageAsset.new(images_root, theme_slug, image_asset)
    end

    def build_theme_scope_asset(scope_hash_asset, theme_image_assets)
      Output::ThemeScopeAsset.new(output_root, theme_slug, scope_hash_asset, theme_image_assets, scope_helper)
    end
  end
end
