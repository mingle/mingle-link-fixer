require 'nokogiri'
require_relative 'absolute_attachment_link'

module Mingle
  class AttachmentLinkFinder

    attr_reader :attachment_links

    def initialize(description)
      @attachment_links = find_links(description)
    end

    private

    def find_links(html)
      html = Nokogiri::HTML.parse(html)
      html.search('a').inject([]) do |memo, anchor|
        href = anchor['href']
        if href =~ /^http/
          memo << AbsoluteAttachmentLink.new(anchor)
        end
        memo
      end
    end

  end
end
