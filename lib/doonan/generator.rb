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
        pass_templates = templates(staging_output_path, extension, load_paths)
        pass_templates.each do |template|
          output = template.render(input.scope)
          render_output_path = File.join(staging_output_path, template.output_filename)
          File.open(render_output_path, 'w') do |f|
            f.puts output
          end
          FileUtils.rm(template.template_path)
        end
      end
      FileUtils.cp_r("#{staging_output_path}/.", output_path)
      # FileUtils.rm_rf(staging_output_path)
    end

    def templates(templates_path, extension, load_paths)
      Dir["#{templates_path}/**/*.#{extension}"].map do |template_path|
        Doonan::Template.new(template_path, load_paths)
      end
    end
  end
end
