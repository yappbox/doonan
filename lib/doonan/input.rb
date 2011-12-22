require 'json'
require 'ostruct'

module Doonan
  class Input
    def initialize(path)
      images_path = File.join(path, 'images')
      settings_path = File.join(path, 'settings.json')
      settings = JSON.parse(File.read(settings_path))
      @scope = OpenStruct.new(settings)
      
      Dir["#{images_path}/*"].each do |image_path|
        image_slug = File.basename(image_path).chomp(File.extname(image_path))
        @scope.send("has_image_#{image_slug}?=".to_sym, true)
        @scope.send("image_path_#{image_slug}=".to_sym, File.basename(image_path))
      end
    end

    attr_reader :scope
  end
end
