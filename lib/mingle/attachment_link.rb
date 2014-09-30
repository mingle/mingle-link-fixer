require_relative 'historical_attachments'
require_relative 'attachment'

module Mingle
  class AttachmentLink
    include Logging

    def initialize(element)
      @element = element
    end

    def rewrite(card, historical_attachments)
      href = @element['href']
      old_attachment_id = if href =~ /projects.*\/attachments\/(\d+)/
        $1
      elsif href =~ /attachments\/[0-9a-f]+\/(\d+)/
        $1
      end
      old_attachment = historical_attachments.find_by_id(old_attachment_id)
      raise "Could not find historical attachment based on #{old_attachment_id}" unless old_attachment
      new_attachment = card.attachments.find { |attachment| attachment.filename == old_attachment.filename }
      if new_attachment
        "[[#{@element.text}|##{card.number}/#{new_attachment.filename}]]"
      else
        raise "Could not find matching attachmen for #{old_attachment.filename} in #{card.attachments.map(&:filename)}"
      end

    end

    def rewrite!(card, historical_attachments)
      new_content = rewrite(card, historical_attachments)
      logger.debug "replacing #{@element.to_html} with #{new_content}"
      @element.replace(Nokogiri::XML::Text.new(new_content, @element.document))
      nil
    rescue => e
      raise "Could not replace #{@element} because: #{e.message}"
    end


  end
end
