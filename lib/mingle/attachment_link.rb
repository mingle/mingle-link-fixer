module Mingle
  class AttachmentLink

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
      "[[#{@element.text}|##{card.number}/#{new_attachment.filename}]]" if new_attachment
    end


  end
end
