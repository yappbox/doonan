module Doonan
  module Commands
    class CleanProject
      include ::Doonan::Logging
      def initialize(config)
        @config = config
      end

      attr_accessor :config

      def perform
        if config.themes
          config.themes.each do |theme_name|
            output_dir = File.join(config.theme_output_root, config.themes_output_prefix, theme_name)
            if File.exist?(output_dir)
              debug("rm -r #{output_dir}")
              FileUtils.rm_r(output_dir)
            end
          end
        else
          output_dir = File.join(config.theme_output_root, config.themes_output_prefix)
          if File.exist?(output_dir)
            debug("rm -r #{output_dir}")
            FileUtils.rm_r(output_dir)
          end
        end
      end
    end
  end
end
