module Mingle
  class AttachmentLinkFinder

    attr_reader :attachment_links

    def initialize(html)
      @html = html
      @attachment_links = []
    end

  end
end
