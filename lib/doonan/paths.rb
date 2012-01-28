module Doonan
  class Paths
    include Enumerable

    attr_reader :root, :pattern

    def initialize(root, pattern)
      @root = root
      @pattern = pattern
    end

    def each
      Dir.glob(File.join(root, pattern)).each do |path|
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
