module Doonan
  class RenderSession
    def initialize(input, output_path, templates_path, extensions)
      Doonan.logger.debug "Initializing render session with scope: #{input.scope.inspect}"
      
      @input = input
      @output_path = output_path
      @templates_path = templates_path
      @extensions = extensions
    end
    
    def perform_generation
      with_rendering_environment do
        @extensions.each do |extension|
          templates_for(extension).each do |template|
            template.replace_with_rendered_output(@input.scope)
          end
        end
        update_output_path
      end
    end
    
  private
  
    def with_rendering_environment(&block)
      prepare_output_directory
      prepare_staging_area
      prepare_compass
      yield
      clean_staging_area
    end
    
    def staging_directory
      File.join(@output_path, "tmp-staging")
    end
    
    def clean_staging_area
      FileUtils.rm_rf(staging_directory)
    end
    
    def load_paths
      [staging_directory]
    end
    
    def prepare_output_directory
      FileUtils.mkdir_p(@output_path)
    end
    
    def prepare_staging_area
      FileUtils.rm_rf(staging_directory)
      FileUtils.cp_r(@templates_path, staging_directory)
    end
    
    def prepare_compass
      Compass.configuration.images_path = @input.images_path
    end
    
    def update_output_path
      FileUtils.cp_r("#{staging_directory}/.", @output_path)
    end
    
    def templates_for(extension)
      Dir["#{staging_directory}/**/*.*.#{extension}"].map do |template_path|
        Doonan::Template.new(template_path, load_paths)
      end
    end
  end
end