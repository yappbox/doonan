module Doonan
  class Generator
    def initialize(path)
      @path = path
    end
    
    def generate(target_path)
      require 'erb'
      require 'tilt'
      require 'sass'
      require 'ostruct'

      scope = OpenStruct.new(:hello_world_color => 'blue')
      template_path = File.join(@path, 'foo.css.scss.erb')
      output = File.read(template_path)
      filename_parts = File.basename(template_path).split('.')
      output_filename = filename_parts.slice(0...2).join('.')
      extensions_to_process = filename_parts.slice(2..-1).reverse
      extensions_to_process.each do |extension|
        template = Tilt[extension].new { |template| output }
        output = template.render(scope)
      end
      FileUtils.mkdir_p(target_path)
      File.open(File.join(target_path, output_filename), 'w') do |f|
        f.puts output
      end
    end
  end
end