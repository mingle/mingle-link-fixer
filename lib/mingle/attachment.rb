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
      [].tap do |attachments|
        xml = @@api.get_attachments_on(number)
        document = Nokogiri::XML.parse(xml)
        document.xpath('./attachments/attachment').each do |element|
          filename = element.xpath('./filename').text
          attachments << Attachment.new(filename)
        end
      end
    end
  end
end
