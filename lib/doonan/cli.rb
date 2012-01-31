require 'thor'
require 'doonan'
require 'fileutils'

module Doonan
  class CLI < Thor
    class_option :config, :default => "config/doonan.rb", :aliases => "-c"
    class_option :debug, :type => :boolean, :default => false, :aliases => "-d"

    desc 'version', 'doonan version'
    def version
      say VERSION
    end

    desc 'compile', 'build themes'
    def compile
      if options[:debug]
        require 'ruby-debug'
        Doonan.logger.level = Logger::DEBUG
        debugger
      end
      pipeline = Pipeline.new(config)
      pipeline.realize
    end

    desc 'clean', 'remove theme output'
    def clean
      output_dir = File.join(config.theme_output_root, config.themes_output_prefix)
      FileUtils.rm_r output_dir if File.exist? output_dir
    end

    desc 'watch', 'recompile themes on change'
    def watch
      require 'fssm'
      recompile

      theme_input_root = config.theme_input_root
      themes_root = config.themes_root

      update_proc = lambda do |base, relative|
        say "file changed #{relative}"
        recompile
      end

      FSSM.monitor do
        path theme_input_root do
          update &update_proc
          delete &update_proc
          create &update_proc
        end

        path themes_root do
          update &update_proc
          delete &update_proc
          create &update_proc
        end
      end
    end

    no_tasks {
      def config
        @config ||= Config.load options[:config]
      end

      def recompile
        clean
        compile
      end
    }
  end
end
