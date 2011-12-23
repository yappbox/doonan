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
