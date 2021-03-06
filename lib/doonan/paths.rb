module Doonan
  class Paths
    include Enumerable

    def self.map(root, glob, &block)
      new(File.expand_path(root), glob).map(&block)
    end

    attr_reader :root, :glob

    def initialize(root, glob)
      @root = root
      @glob = glob
    end

    def each
      Dir.glob(File.join(root, glob)).each do |path|
        next unless File.file?(path)
        path_from_root = path[root.size+1, path.size]
        yield path_from_root
      end
    end

    def inspect
      "<#{self.class.name} #{to_a.inspect}>"
    end
  end
end
