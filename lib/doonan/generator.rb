require 'erb'
require 'tilt'
require 'sass'

module Doonan
  class Generator
    def initialize(path)
      @path = path
    end
    
    def generate(target_path)
      require 'erb'
      require 'tilt'
      template = Tilt.new(File.join(@path, 'foo.scss.erb'))
      output = template.render(self, :hello_world_color => 'blue')
      FileUtils.mkdir_p(target_path)
      File.open(File.join(target_path, 'foo.css'), 'w') do |f|
        f.puts output
      end
    end
  end
end