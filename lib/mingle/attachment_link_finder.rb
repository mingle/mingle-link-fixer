require 'nokogiri'
require_relative 'attachment_link'

module Mingle
  class AttachmentLinkFinder

    attr_reader :attachment_links, :document

    def initialize(html)
      @attachment_links = find_links(html)
    end

    private

    def find_links(html)
      @document = Nokogiri::HTML(html)
      @document.xpath('//a').inject([]) do |memo, anchor|
        href = anchor['href']
        if href =~ /attachments/
          memo << AttachmentLink.new(anchor)
        end
        memo
      end
    end

  end
end
