require 'nokogiri'
require_relative 'api'

module Mingle
  class Page
    def self.all
      pages = []
      begin
        pages_xml = @@api.get_all_pages
        document = Nokogiri::XML.parse(pages_xml)
        document.xpath('./pages/page').each do |element|
          pages << Page.new({ content: element.xpath('./content').text,
                              identifier: element.xpath('./identifier').text,
                              name: element.xpath('./name').text
                              })
        end
        return pages
      rescue => e
        Logging.error "Unable to get pages due to #{e.message}"
      end
    end

    def self.api=(api)
      @@api = api
    end

    def self.find_by_identifier(identifier)
      Logging.debug("fetching page #{identifier}")
      page_xml = @@api.get_page(identifier)
      document = Nokogiri::XML.parse(page_xml)
      Page.new({ content: document.xpath('./page/content').text, identifier: document.xpath('./page/identifier').text, name: document.xpath('./page/name').text })
    end

    attr_accessor :content, :identifier, :name

    def initialize(params)
      @content = params[:content]
      @identifier = params[:identifier]
      @name = params[:name]
    end

    def content=(content)
      @content = remove_enclosing_html_doc_and_body(content)
    end

    def attachments
      @attachments ||= Attachment.find_all_by_page_identifier(identifier)
    end

    def save!
      @@api.save_page(self)
    end

    def to_xml
      Nokogiri::XML::Builder.new { |xml|
        xml.page {
          xml.content(@content)
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
