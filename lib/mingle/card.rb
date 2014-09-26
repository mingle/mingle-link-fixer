require 'nokogiri'
require_relative 'api'

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
          yielder.yield Card.find_by_number(number)
        end
      end
    end

    def self.find_by_number(number)
      Logging.debug("fetching card ##{number}")
      card_xml = @@api.get_card(number)
      Card.new(card_xml)
    end

    def self.api=(api)
      @@api = api
    end

    attr_accessor :description, :number, :name

    def initialize(xml)
      document = Nokogiri::XML.parse(xml)
      @description = document.xpath('./card/description').text
      @number = document.xpath('./card/number').text.to_i
      @name = document.xpath('./card/name').text
    end

    def attachments
      @attachments ||= Attachment.find_all_by_card_number(number)
    end

    def save!
      @@api.save_card(self)
    end

    def to_xml
      Nokogiri::XML::Builder.new { |xml|
        xml.card {
          xml.description(@description)
        }
      }.to_xml
    end

  end
end
