require 'json'

module Doonan
  class Input
    def initialize(path)
      @images_path = File.join(path, 'images')
      @scope = InputScope.new
      @scope.merge_json!(File.read(File.join(path, 'settings.json')))
      @scope.merge!(ImagesScope.from_path(images_path))
    end

    attr_reader :scope
    attr_reader :images_path
  end
end
