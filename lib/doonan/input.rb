require 'json'
require 'ostruct'

module Doonan
  class Input
    def initialize(path)
      images_path = File.join(path, 'images')
      settings_path = File.join(path, 'settings.json')
      settings = JSON.parse(File.read(settings_path))
      @scope = OpenStruct.new(settings)
    end

    attr_reader :scope
  end
end
