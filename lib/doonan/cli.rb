require 'thor'
require 'doonan'

module Doonan
  class CLI < Thor
    class_option :themefile, :default => "Themefile", :aliases => "-c"

    desc 'version', 'doonan version'
    def version
      say VERSION
    end

    desc 'compile', 'build themes'
    def compile
      say 'TODO doonan compile'
    end

    desc 'watch', 'compile themes then watch for changes'
    def watch
      config = Doonan::Config.load options[:themefile]
      say config.inspect
    end
  end
end
