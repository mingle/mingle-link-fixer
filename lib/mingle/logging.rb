require 'logger'

module Mingle
  module Logging

    LOGGER = Logger.new(STDOUT).tap { |l| l.level = ENV['VERBOSE'] ? Logger::DEBUG : Logger::INFO }

    def self.info(msg)
      LOGGER.info(msg)
    end

    def self.debug(msg)
      LOGGER.debug(msg)
    end

    def logger
      LOGGER
    end

  end
end
