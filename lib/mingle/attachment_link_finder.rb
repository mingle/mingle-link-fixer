require 'nokogiri'
require_relative 'attachment_link'

module Mingle
  class AttachmentLinkFinder

    attr_reader :attachment_links, :card_description_document

    def initialize(description)
      @attachment_links = find_links(description)
    end

    private

    def find_links(html)
      @card_description_document = Nokogiri::HTML.parse(html)
      @card_description_document.search('a').inject([]) do |memo, anchor|
        href = anchor['href']
        if href =~ /attachments/
          memo << AttachmentLink.new(anchor)
        end
        memo
      end
    end

  end
end
