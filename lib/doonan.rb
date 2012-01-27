require "doonan/version"
require 'doonan/asset'
require 'doonan/assets'
require 'doonan/variable_resolver'
require 'doonan/scope'
require 'doonan/paths'
require 'doonan/pipeline'
require "logger"

module Doonan
  module_function
  def logger
    @logger ||= begin
      logger = Logger.new(STDOUT)
      logger.level = Logger::WARN
      logger
    end
  end

  def logger=(logger)
    @logger = logger
  end
end
