module Doonan
  class Pipeline
    def initialize(input_root, themes_root, output_root, images_root, input_glob='**/*')
      @input_root = File.expand_path(input_root || 'templates')
      @themes_root = File.expand_path(themes_root || 'themes')
      @output_root = File.expand_path(output_root || 'sass')
      @images_root = File.expand_path(images_root || 'images')
      @input_glob = input_glob || '**/*'
    end

    def add_input_file(path)

    end

    def add_theme(path)
      
    end
  end
end
