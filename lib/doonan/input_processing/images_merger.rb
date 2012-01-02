require 'hashie'

module Doonan
  module InputProcessing
    class ImagesMerger
      def merge(images_path, merge_target)
        mergee = { :images => {}, :image_lists => {}}
        add_image_info_from_path(mergee, images_path)
        merge_target.merge(mergee)
      end

      def add_image_info_from_path(hash, images_path)
        FileUtils.cd(images_path) do
          Dir["*"].each do |images_dir_entry|
            if Dir.exists?(images_dir_entry)
              add_image_list(hash, images_dir_entry)
            else
              add_image(hash, images_dir_entry)
            end
          end
        end
      end

      private
        def add_image(hash, image_path)
          hash[:images][get_slug(image_path)] = get_image_struct(image_path)
        end

        def add_image_list(hash, image_list_path)
          list_slug = image_list_path
          image_list = Dir["#{image_list_path}/*"].map do |list_image_path|
            get_image_struct(list_image_path)
          end
          hash[:image_lists][list_slug.to_sym] = image_list
        end

        def get_slug(image_path)
          File.basename(image_path).chomp(File.extname(image_path))
        end

        def get_image_struct(image_path)
          { :slug => get_slug(image_path), :path => image_path }
        end
    end
  end
end