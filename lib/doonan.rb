require 'logger'
require 'doonan/version'
require 'doonan/logging'
require 'doonan/config'
require 'doonan/pipeline'

module Doonan
  def self.logger
    @logger ||= begin
      logger = Logger.new(STDOUT)
      logger.level = Logger::WARN
      logger
    end
  end

  def self.logger=(logger)
    @logger = logger
  end
end
