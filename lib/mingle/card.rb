require 'nokogiri'
require_relative 'api'

module Mingle
  class Card

    def self.all(options={})
      options = {starting_from: '1'}.merge(options)
      Logging.debug "Mingle API => #{@@api.inspect}"
      starting_card_number = options[:starting_with].to_i
      max_card_number = unless options[:limit]
        mql = "SELECT MAX(number)"
        results = @@api.execute_mql(mql)
        Logging.debug "#{mql}: #{results.inspect}"
         results[0]['max_number'].to_i
       else
         starting_card_number + options[:limit].to_i
       end
      Enumerator.new do |yielder|
        (starting_card_number..max_card_number).to_a.each do |number|
          begin
            yielder.yield Card.find_by_number(number)
          rescue => e
            Logging.error "Unable to fetch card ##{number} due to #{e.message}"
          end
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

    def description=(desc)
      @description = remove_enclosing_html_doc_and_body(desc)
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

    private

    DOCTYPE_REGEX = /^<!DOCTYPE html PUBLIC "-\/\/W3C\/\/DTD HTML 4.0 Transitional\/\/EN" "http:\/\/www.w3.org\/TR\/REC-html40\/loose.dtd\">/

    def remove_enclosing_html_doc_and_body(html)
      html.gsub(DOCTYPE_REGEX, '').strip
        .gsub(/<html>/, '').strip
        .gsub(/<body>/, '').strip
        .gsub(/<\/html>$/, '').strip
        .gsub(/<\/body>$/, '').strip
    end

  end
end
