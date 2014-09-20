module Mingle
  class Card

    def self.all
      Logging.debug "Mingle API => #{@@api.inspect}"
      results = @@api.execute_mql("SELECT MAX(number)")
      max_card_number = results[0]['max_number'].to_i
      Enumerator.new do |yielder|
        (max_card_number..1).each do |number|
          card_xml = @@api.get_card(number)
          yielder.yield Card.new(card_xml)
        end
      end
    end

    def self.api=(api)
      @@api = api
    end

    attr_reader :description

    def initialize(xml)
      document = Nokogiri::XML.parse(xml)
      @description = document.xpath('./card/description').text
    end

  end
end
