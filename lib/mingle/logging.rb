require 'logger'

module Mingle
  module Logging

    VERBOSE = (ENV['VERBOSE'] == 'true')
    LOGGER = Logger.new(STDOUT).tap { |l| l.level = VERBOSE ? Logger::DEBUG : Logger::INFO }

    def self.info(msg)
      LOGGER.info(msg)
    end

    def self.debug(msg)
      LOGGER.debug(msg)
    end

    def self.error(msg)
      LOGGER.error(msg)
    end

    def logger
      LOGGER
    end

  end
end
