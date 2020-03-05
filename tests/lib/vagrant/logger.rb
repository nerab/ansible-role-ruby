require 'logger'

module Vagrant
  module Logger
    def logger=(new_logger)
      @logger = new_logger
    end

    def logger
      @logger ||= ::Logger.new(STDERR).tap { |logger| logger.level = ::Logger::ERROR }
    end
  end
end
