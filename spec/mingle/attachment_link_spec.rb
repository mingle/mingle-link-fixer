require 'ostruct'
require 'nokogiri'
require_relative '../../lib/mingle/attachment_link'

module Mingle

  describe AttachmentLink do

    let(:attachments) { [Attachment.new('papillon.jpg'), Attachment.new('doc.pdf'), Attachment.new('pomeranian.jpg')] }

    let(:card) { OpenStruct.new(number: 123, attachments: attachments) }

    let(:document) { Nokogiri::HTML::Document.new }

    let(:wrapper_element) { Nokogiri::XML::Node.new('p', document) }

    let(:historical_attachments) { HistoricalAttachments.new(File.join(__dir__, '..', 'data', 'extracted_export')) }

    it "knows how to rewrite absolute links to attachment IDs" do
      link = link('http://mingle.osito.org/projects/bonito/attachments/7411')
      expect(link.rewrite(card, historical_attachments)).to eq '[[Link text|#123/pomeranian.jpg]]'
    end

    it "knows how to rewrite absolute links to hashed attachment paths" do
      link = link('http://mingle.bonito.com/attachments/9f1688c2f806cb522fd55ec31f704026/30003/papillon.png')
      expect(link.rewrite(card, historical_attachments)).to eq '[[Link text|#123/papillon.jpg]]'
    end

    it "can rewrite in-place" do
      link = link('http://mingle.osito.org/projects/bonito/attachments/7411')
      link.rewrite!(card, historical_attachments)
      expect(document.to_html.strip).to eq(<<-HTML.strip)
  <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
<p>[[Link text|#123/pomeranian.jpg]]</p>
HTML
    end

    private

    def link(href)
      a = Nokogiri::XML::Node.new('a', document)
      a['href'] = href
      a.add_child(Nokogiri::XML::Text.new('Link text', document))
      wrapper_element.add_child(a)
      document.add_child(wrapper_element)
      AttachmentLink.new a
    end

  end

end
