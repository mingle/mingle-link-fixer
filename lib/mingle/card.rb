module Mingle
  class Card

    def self.all
      
    end

    attr_reader :description

    def initialize(xml)
      document = Nokogiri::XML.parse(xml)
      @description = document.xpath('./card/description').text
    end

  end
end
