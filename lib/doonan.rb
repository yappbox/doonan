require "doonan/version"
require 'doonan/pipeline_builder'
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
