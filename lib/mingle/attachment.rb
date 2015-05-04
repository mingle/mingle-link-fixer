require 'nokogiri'

module Mingle
  class Attachment

    attr_reader :filename

    def initialize(filename)
      @filename = filename
    end

    def self.api=(api)
      @@api = api
    end

    def self.find_all_by_card_number(number)
      xml = @@api.get_attachments_on(number)
      collect_attachments(xml)
    end

    def self.find_all_by_page_identifier(identifier)
      xml = @@api.get_attachments_for_page(identifier)
      att = collect_attachments(xml)
    end

    def self.collect_attachments(xml)
      attachments = []
      document = Nokogiri::XML.parse(xml)
      document.xpath('./attachments/attachment').each do |element|
        filename = element.xpath('./file_name').text
        attachments << Attachment.new(filename)
      end
      return attachments
    end
  end
end
