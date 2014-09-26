require 'nokogiri'

module Mingle
  class Card

    def self.all
      Logging.debug "Mingle API => #{@@api.inspect}"
      mql = "SELECT MAX(number)"
      results = @@api.execute_mql(mql)
      Logging.debug "#{mql}: #{results.inspect}"
      max_card_number = results[0]['max_number'].to_i
      Enumerator.new do |yielder|
        (1..max_card_number).to_a.reverse.each do |number|
          Logging.info("Fetching card ##{number}")
          card_xml = @@api.get_card(number)
          yielder.yield Card.new(card_xml)
        end
      end
    end

    def self.api=(api)
      @@api = api
    end

    attr_reader :description, :number, :name

    def initialize(xml)
      document = Nokogiri::XML.parse(xml)
      @description = document.xpath('./card/description').text
      @number = document.xpath('./card/number').text.to_i
      @name = document.xpath('./card/name').text
    end

    def attachments
      @attachments ||= Attachment.find_all_by_card_number(number)
    end

  end
end
