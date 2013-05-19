require 'logger'
require 'doonan/version'
require 'doonan/logging'
require 'doonan/config'
require 'doonan/pipeline'
require 'doonan/commands/clean_project'
require 'doonan/commands/update_project'

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
