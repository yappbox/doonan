require "doonan/version"
require "doonan/generator"
require "doonan/input"
require "doonan/input_scope"
require "doonan/images_scope"
require "doonan/render_session"
require "doonan/template"
require "doonan/css_helper"
require "logger"

module Doonan
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
  module_function :logger, :logger=
end
