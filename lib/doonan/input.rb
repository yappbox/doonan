require 'json'
require 'hashie'

module Doonan
  class Input
    def initialize(path)
      @images_path = File.join(path, 'images')
      @scope = scope_struct_from_json(File.join(path, 'settings.json'))
      enhance_scope_with_images_info(@images_path)
    end

    attr_reader :scope
    attr_reader :images_path

  private
    def scope_struct_from_json(settings_path)
      settings = JSON.parse(File.read(settings_path))
      pattern, variables = get_variables(settings)
      transform_values(settings) do |value|
        if value.class == String
          value.gsub(pattern) do |match|
            variables[match]
          end
        else
          value
        end
      end
      Hashie::Mash.new(settings)
    end

    def enhance_scope_with_images_info(images_path)
      @scope.images = Hashie::Mash.new
      @scope.image_lists = Hashie::Mash.new
      FileUtils.cd(images_path) do
        Dir["*"].each do |images_dir_entry|
          if Dir.exists?(images_dir_entry)
            add_image_list_to_scope(images_dir_entry)
          else
            add_image_to_scope(images_dir_entry)
          end
        end
      end
    end

    def get_variables(json_object)
      variables = {}
      names = []
      json_object.delete_if do |key, value|
        if key =~ /^\$(\w+)/
          names << $1
          variables[key] = value.to_s
          true
        else
          false
        end
      end
      [Regexp.new("\\$(#{names.join('|')})"), variables]
    end

    def transform_values(json_object, &block)
      json_object.each_pair do |key, value|
        json_object[key] = transform_value(value, &block)
      end
      json_object
    end

    def transform_value(value, &block)
      case value
      when Hash
        transform_values(value, &block)
      when Array
        value.each_with_index {|v, i| value[i] = transform_value(v, &block) }
        value
      else
        yield value
      end
    end

    def add_image_to_scope(image_path)
      @scope.images[get_slug(image_path)] = get_image_struct(image_path)
    end

    def add_image_list_to_scope(image_list_path)
      list_slug = image_list_path
      image_list = Dir["#{image_list_path}/*"].map do |list_image_path|
        get_image_struct(list_image_path)
      end
      @scope.image_lists[list_slug] = image_list
    end

    def get_slug(image_path)
      File.basename(image_path).chomp(File.extname(image_path))
    end

    def get_image_struct(image_path)
      Hashie::Mash.new(:slug => get_slug(image_path), :path => image_path)
    end
  end
end
