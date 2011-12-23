module Doonan
  class Generator
    def initialize(templates_path)
      @templates_path = templates_path
    end

    def generate(input_path, output_path, extensions)
      input = Doonan::Input.new(input_path)
      FileUtils.mkdir_p(output_path)
      staging_output_path = File.join(output_path, "tmp-staging")
      FileUtils.rm_rf(staging_output_path)
      FileUtils.cp_r(@templates_path, staging_output_path)
      Compass.configuration.images_path = File.join(input_path, 'images')
      load_paths = [staging_output_path]
      extensions.each_with_index do |extension|
        templates = templates_for(staging_output_path, extension, load_paths)
        templates.each do |template|
          File.open(template.output_filename, 'w') do |f|
            f.puts template.render(input.scope)
          end
          FileUtils.rm(template.template_path)
        end
      end
      FileUtils.cp_r("#{staging_output_path}/.", output_path)
      # FileUtils.rm_rf(staging_output_path)
    end
    
  private

    def templates_for(templates_path, extension, load_paths)
      Dir["#{templates_path}/**/*.#{extension}"].map do |template_path|
        Doonan::Template.new(template_path, load_paths)
      end
    end
  end
end
