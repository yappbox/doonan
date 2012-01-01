require 'hashie'

module Doonan
  class ImagesScope < Hashie::Mash
    def self.from_path(images_path)
      scope = new
      scope.images = Hashie::Mash.new
      scope.image_lists = Hashie::Mash.new
      scope.add_image_info_from_path(images_path)
      scope
    end

    def add_image_info_from_path(images_path)
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

    private
      def add_image_to_scope(image_path)
        self.images[get_slug(image_path)] = get_image_struct(image_path)
      end

      def add_image_list_to_scope(image_list_path)
        list_slug = image_list_path
        image_list = Dir["#{image_list_path}/*"].map do |list_image_path|
          get_image_struct(list_image_path)
        end
        self.image_lists[list_slug] = image_list
      end

      def get_slug(image_path)
        File.basename(image_path).chomp(File.extname(image_path))
      end

      def get_image_struct(image_path)
        Hashie::Mash.new(:slug => get_slug(image_path), :path => image_path)
      end
  end
end