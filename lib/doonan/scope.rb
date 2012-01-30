require 'hashie'
require 'doonan/scope/images'
require 'doonan/scope/image_info'

module Doonan
  class Scope < ::Hashie::Mash
    def self.variable_resolver
      @variable_resolver ||= begin
        require 'doonan/variable_resolver'
        VariableResolver.new
      end
    end

    def images
      unless key?('images')
        self['images'] = Images.new
      end
      self['images']
    end

    def add_image_info(slug_path, image_info)
      images = self.images.get_path(slug_path)
      images.add_image_info(image_info)
    end

    def resolve_variables
      self.class.variable_resolver.resolve(self)
    end

    def result(template)
      template.result(binding)
    end
  end
end
