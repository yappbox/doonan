module Doonan
  module HashParser
    LOADERS = {
      '.yml' => lambda {
        require 'doonan/hash_parser/yaml'
        Doonan::HashParser::YAML.new
      },
      '.json' => lambda {
        require 'doonan/hash_parser/json'
        Doonan::HashParser::JSON.new
      }
    }

    @parsers = {}

    def self.parser(path)
      ext = File.extname(path).downcase
      return @parsers[ext] if @parsers.key? ext
      @parsers[ext] = LOADERS[ext].call()
    end

    def self.parse(path, data)
      parser(path).parse(data)
    end
  end
end
