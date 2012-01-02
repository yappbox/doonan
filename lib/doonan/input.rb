require 'doonan/input_processing/variable_resolver'
require 'doonan/input_processing/images_merger'
require 'doonan/input_processing/json_merger'

module Doonan
  class Input
    def initialize(path)
      @images_path = File.join(path, 'images')
      json_path = File.join(path, 'settings.json')
      scope = Hashie::Mash.new
      scope = json_merger.merge(json_path, scope)
      scope = images_merger.merge(images_path, scope)
      @scope = variable_resolver.resolve(scope)
    end
    
    def json_merger
      InputProcessing::JsonMerger.new
    end

    def images_merger
      InputProcessing::ImagesMerger.new
    end

    def variable_resolver
      InputProcessing::VariableResolver.new
    end

    attr_reader :scope
    attr_reader :images_path
  end
end
