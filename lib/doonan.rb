require "doonan/version"
require "doonan/generator"

module Doonan
  def create_from_directory(path)
    Doonan::Generator.new(path)
  end
  module_function :create_from_directory
end
