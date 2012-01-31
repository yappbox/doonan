module Doonan
  class Config
    attr_reader :theme_input_root, :theme_input_glob, :themes_root, :theme_output_root, :images_output_root, :scope_helper

    def initialize(project_root, theme_input_root, theme_input_glob, themes_root, theme_output_root, images_output_root, *helper_modules)
      project_root ||= '.'
      @theme_input_root = File.expand_path(theme_input_root || 'theme_template', project_root)
      @theme_input_glob = theme_input_glob || '**/*.*'
      @themes_root = File.expand_path(themes_root || 'themes', project_root)
      @theme_output_root = File.expand_path(theme_output_root || 'sass/themes', project_root)
      @images_output_root = File.expand_path(images_output_root || 'images/themes', project_root)
      @scope_helper = Module.new
      unless helper_modules.empty?
        @scope_helper.instance_eval do
          include *helper_modules
        end
      end
    end

    def self.load(config_file)
      config_dsl = DSL.new
      config_dsl.instance_eval(File.read(config_file), config_file)
      config_dsl.config
    end

    # Config DSL
    class DSL
      def initialize
        @scope_helpers = []
      end

      # Build {Doonan::Config} from DSL
      def config
        Config.new(@project_root, @theme_input_root, @theme_input_glob, @themes_root, @theme_output_root, @images_output_root, *@scope_helpers)
      end

      # The project root directory used to expand relative config paths.
      #
      # @param [String] base path of project, defaults to '.'
      # @returns [String]
      def project_root(path)
        @project_root = path
      end

      # The theme template directory. This directory serves as the template for each theme's output.
      #
      # The theme template is made up of static files and templated files.
      # Its contents (matching #theme_input_glob) will be either copied or processed
      # with the theme scope depending on if the template asset is a template itself.
      # The path is preserved for each asset. The extensions of templated files are stripped.
      #
      # @param [String] path to the theme template directory, defaults to 'theme_template'
      def theme_input_root(path)
        @theme_input_root = path
      end

      # A pattern for matching files to be processed in the theme pipeline.
      #
      # @param [String] pattern of theme input files, defaults to '**/*.*'
      def theme_input_glob(glob)
        @theme_input_glob = glob
      end

      # The root of theme definitions.
      #
      # @param [String] path to the root of theme definitions.
      def themes_root(path)
        @themes_root = path
      end

      # The theme output root of the doonan theme pipeline.
      #
      # @param [String] path to output, defaults to 'sass/themes'
      def theme_output_root(path)
        @theme_output_root = path
      end

      # The image output root of the doonan theme pipeline.
      #
      # @param [String] path to output, defaults to 'images/themes'
      def images_output_root(path)
        @images_output_root = path
      end

      # Scope helper modules. Helper modules will be mixed into the doonan scope.
      #
      # @param [Module] helper module.
      def scope_helper(*helpers)
        helpers.each do |helper|
          raise 'scope_helper should be a Module' unless helper.instance_of? Module
          @scope_helpers << helper
        end
      end
    end
  end
end
