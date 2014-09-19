module Mingle
  class AttachmentLink

    def initialize(element)
      @element = element
    end

    def rewrite(card, historical_attachments)
      if @element['href'] =~ /projects.*\/attachments\/(\d+)/
        old_attachment = historical_attachments.find_by_id($1)
        new_attachment = card.attachments.find { |attachment| attachment.filename == old_attachment.filename }
        "[[#{@element.text}|##{card.number}/#{new_attachment.filename}]]"
      end
    end


  end
end
