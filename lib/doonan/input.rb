require 'json'
require 'ostruct'

module Doonan
  class Input
    def initialize(path)
      images_path = File.join(path, 'images')
      settings_path = File.join(path, 'settings.json')
      settings = JSON.parse(File.read(settings_path))
      @scope = OpenStruct.new(settings)

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

    attr_reader :scope

  private

    def add_image_to_scope(image_path)
      image_slug = get_slug(image_path)
      @scope.send("has_image_#{image_slug}?=".to_sym, true)
      @scope.send("image_#{image_slug}=".to_sym, get_image_struct(image_path))
    end

    def add_image_list_to_scope(image_list_path)
      list_slug = image_list_path
      @scope.send("has_#{list_slug}_image_list?=".to_sym, true)
      image_list = Dir["#{image_list_path}/*"].map do |list_image_path|
        get_image_struct(list_image_path)
      end
      @scope.send("#{list_slug}_images=".to_sym, image_list)
    end

    def get_slug(image_path)
      File.basename(image_path).chomp(File.extname(image_path))
    end
    
    def get_image_struct(image_path)
      OpenStruct.new(:name => get_slug(image_path), :path => image_path)
    end
  end
end
