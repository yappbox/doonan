module Doonan
  class Generator
    def initialize(templates_path)
      @templates_path = templates_path
      self.class.add_compass_load_paths_once
      Compass.configuration.images_path = 'images'
    end
    
    def generate(input_path, output_path, extensions)
      input = Doonan::Input.new(input_path)
      staging_output_path = File.join(output_path, "tmp")
      FileUtils.mkdir_p(staging_output_path)
      FileUtils.cp_r(Dir["#{@templates_path}/*"], staging_output_path)
      FileUtils.cd(input_path) do
        extensions.each_with_index do |extension|
          pass_templates = templates(staging_output_path, extension)
          pass_templates.each do |template|
            output = template.render(input.scope)
            render_output_path = File.join(staging_output_path, template.output_filename)
            File.open(render_output_path, 'w') do |f|
              f.puts output
            end
            FileUtils.rm(template.template_path)
          end
        end
      end
      FileUtils.cp_r(Dir["#{staging_output_path}/*"], output_path)
      # FileUtils.rm_rf(staging_output_path)
    end
    
    def templates(templates_path, extension)
      Dir["#{templates_path}/**/*.#{extension}"].map do |dir_entry|
        Doonan::Template.new(dir_entry)
      end
    end
  
  private
    def self.add_compass_load_paths_once
      unless @__added_compass_load_paths_once
        Sass::Engine::DEFAULT_OPTIONS[:load_paths].concat(Compass.sass_engine_options[:load_paths])
      end
      @__added_compass_load_paths_once = true
    end
  end
end