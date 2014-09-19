require 'yaml'
require_relative 'attachment'

module Mingle
  class HistoricalAttachments

    def initialize(path)
      @path = path
      @attachments = []
      Dir[File.join(@path, 'attachments_*.yml')].each do |file|
        @attachments += YAML.load_file(file)
      end
    end

    def size
      @attachments.size
    end

    def find_by_id(id)
      attachment = @attachments.find { |attachment| attachment['id'].to_s == id.to_s }
      Attachment.new(attachment['file']) if attachment
    end

  end
end
