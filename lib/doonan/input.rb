require 'ostruct'

module Doonan
  class Input
    def initialize(path)
      @path = path
    end
    
    def images_path
      
    end
    
    def settings
      
    end
    
    def scope
      OpenStruct.new(:hello_world_color => 'blue')
    end
  end
end