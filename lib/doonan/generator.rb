module Doonan
  class Generator
    def initialize(templates_path)
      @templates_path = templates_path
    end
    
    def templates
      @templates ||= begin
        Dir["#{@templates_path}/*"].map do |dir_entry|
          Doonan::Template.new(dir_entry)
        end
      end
    end
    
    def generate(input_path, output_path)
      input = Doonan::Input.new(input_path)
      FileUtils.mkdir_p(output_path)
      templates.each do |template|
        output = template.render(input.scope)
        render_output_path = File.join(output_path, template.output_filename)
        File.open(render_output_path, 'w') do |f|
          f.puts output
        end
      end
    end
  end
end