module Doonan
  class Config
    attr_reader :theme_input_root, :theme_input_glob, :themes_root, :theme_output_root, :images_output_root, :themes_output_prefix, :scope_helper

    def initialize(project_root, theme_input_root, theme_input_glob, themes_root, theme_output_root, images_output_root, themes_output_prefix, *helper_modules)
      project_root ||= '.'
      @theme_input_root = File.expand_path(theme_input_root || 'theme_template', project_root)
      @theme_input_glob = theme_input_glob || '**/*.*'
      @themes_root = File.expand_path(themes_root || 'themes', project_root)
      @theme_output_root = File.expand_path(theme_output_root || 'sass', project_root)
      @images_output_root = File.expand_path(images_output_root || 'images', project_root)
      @themes_output_prefix = themes_output_prefix || 'themes'
      @scope_helper = Module.new
      unless helper_modules.empty?
        @scope_helper.instance_eval do
          include *helper_modules
        end
      end
    end

    def self.load(config_file)
      DSL.new(config_file).config
    end

    # Config DSL
    class DSL
      def initialize(filename=nil, &block)
        @scope_helpers = []
        instance_eval(File.read(filename), filename) if filename
        if block_given?
          @block_self = eval 'self', block.binding
          instance_eval(&block)
          @block_self = nil
        end
      end

      # Build {Doonan::Config} from DSL
      def config
        Config.new(@project_root, @theme_input_root, @theme_input_glob, @themes_root, @theme_output_root, @images_output_root, @themes_output_prefix, *@scope_helpers)
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
      # @param [String] path to output, defaults to 'sass'
      def theme_output_root(path)
        @theme_output_root = path
      end

      # The image output root of the doonan theme pipeline.
      #
      # @param [String] path to output, defaults to 'images'
      def images_output_root(path)
        @images_output_root = path
      end

      # a prefix to the output root so theme outputs are isolated from other project assets
      # gives a convenient way to delete all output.
      #
      # output/prefix/slug/**/*.*
      #
      # @param [String] prefix, defaults to 'themes'
      def themes_output_prefix(prefix)
        @themes_output_prefix = prefix
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

      def method_missing(m, *args, &block)
        if @block_self && @block_self.respond_to?(m)
          @block_self.send(m, *args, &block)
        else
          super(m, *args, &block)
        end
      end
    end
  end
end
