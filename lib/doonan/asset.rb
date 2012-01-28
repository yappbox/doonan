require 'fileutils'

module Doonan
  # abstract class representing a file asset
  # it represents a node in an asset hierarchy
  # it has methods for updating that hierarchy bottom up for file system watching
  # and methods for forcing regeneration of a specific generated asset for serving
  class Asset
    include FileUtils

    attr_reader :root, :path, :dependencies, :dependents

    # root should be absolute path
    # path should be relative and contain no . or ..
    def initialize(root, path)
      @root = root
      @path = path
      @dependencies = []
      @dependents = []
      @realized = false
    end

    # Absolute path to asset file
    def fullpath
      @fullpath = File.join(root, path)
    end

    # Whether the underlying file exists
    #
    # For static assets, #exist? starts out as true
    # but #realized? is false if the asset has not be processed
    def exist?
      File.exist? fullpath
    end

    def inspect
      "<#{self.class.name} #{fullpath}>"
    end

    # The absolute path to the directory that contains the asset.
    # useful for mkdir_p
    def dir
      @dir ||= File.dirname(fullpath)
    end

    # The extension of the asset
    def ext
      @ext ||= File.extname(path)
    end

    # The path without the asset extension
    def path_without_ext
      @path_without_ext ||= path.chomp(ext)
    end

    # Whether the asset has been realized
    def realized?
      @realized
    end

    # Realizes the asset, is descendant through the hierarchy
    def realize
      return if @realized
      realize_dependencies
      realize_self
      @realized = true
    end

    # Unrealizes the asset, is ascendant through the hierarchy
    # used when an asset changes or is added as a dependency
    def unrealize
      return unless @realized
      unrealize_dependents
      unrealize_self
      @realized = false
    end

    # Descendant version of unrealize to force dependencies and self back into an unrealized state.
    #
    # Used to force regeneration of a specific generated asset.
    def descendant_unrealize
      # force unrealize
      unrealize_self
      @realized = false
      dependencies.each do |dependency|
        dependency.descendant_unrealize
      end
    end

    # Unrealize and remove from hierarchy.
    #
    # Remove ascendant through hierarchy unless an asset overrides propagation.
    # Used when an asset is deleted.
    def remove
      unrealize
      remove_from_dependencies
      remove_from_dependents
    end

    # Read underlying asset file
    def read
      open(fullpath, 'r') do |io|
        if block_given?
          yield io
        else
          io.read
        end
      end
    end

    private
    # Used by subclass realize_self to write to underlying asset file
    def write(data=nil, &block)
      mkdir_p dir
      open(fullpath, 'w') do |io|
        io.write data if data
        yield io if block_given?
      end
    end

    # Used by subcless unrealize_self to delete the underlying asset file
    def delete
      File.delete fullpath
      dirname = File.dirname(fullpath)
      while dirname != root
        Dir.rmdir(dirname)
        dirname = File.dirname(dirname)
      end
    rescue Errno::ENOTEMPTY
    end

    # Used by subclass to add a dependency to the hierarchy
    def add_dependency(dependency)
      unrealize
      dependencies.push(dependency)
      dependency.dependents.push(self)
      dependency
    end

    # Remove self from dependencies hierarchy
    def remove_from_dependencies
      dependencies.each do |dependency|
        dependency.dependents.delete(self)
      end
      dependencies.clear
    end

    # Remove self from dependents hierarchy
    #
    # Calls propagate_remove with former dependents
    def remove_from_dependents
      dependents.each do |dependent|
        dependent.dependencies.delete(self)
      end
      former_dependents = dependents.dup
      dependents.clear
      propagate_remove(former_dependents)
    end

    # Called after #remove_from_dependents to propagate #remove
    # unless overriden not to.
    def propagate_remove(former_dependents)
      former_dependents.each do |former_dependent|
        former_dependent.remove
      end
    end

    # realize cascades to dependencies
    def realize_dependencies
      dependencies.each do |dependency|
        dependency.realize
      end
    end

    # unrealize cascades to dependents
    def unrealize_dependents
      dependents.each do |dependents|
        dependents.unrealize
      end
    end

    # subclass must implement this method to generate and/or process the underlying asset file.
    def realize_self
      raise NotImplementedError
    end

    # subclass must implement this method to remove artifacts of #realize_self.
    # Must be an inverse of #realize_self
    def unrealize_self
      raise NotImplementedError
    end
  end
end
