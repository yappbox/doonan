module Doonan
  class Pipeline
    def initialize(input_root, themes_root, output_root, images_root)
      @input_root = input_root || 'templates'
      @themes_root = themes_root || 'themes'
      @output_root = output_root || 'sass'
      @images_root = images_root || 'images'
    end
  end
end
