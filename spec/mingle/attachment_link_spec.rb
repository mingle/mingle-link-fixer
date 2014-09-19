require 'ostruct'
require_relative '../../lib/mingle/attachment_link'

module Mingle

  describe AttachmentLink do

    let(:attachments) { [Attachment.new('junk.jpg'), Attachment.new('doc.pdf'), Attachment.new('pomeranian.jpg')] }

    let(:card) { OpenStruct.new(number: 123, attachments: attachments) }

    let(:historical_attachments) { HistoricalAttachments.new(File.join(__dir__, '..', 'data', 'extracted_export')) }

    it "knows how to rewrite absolute links" do
      link = link('http://mingle.osito.org/projects/bonito/attachments/7411')
      expect(link.rewrite(card, historical_attachments)).to eq '[[Link text|#123/pomeranian.jpg]]'
    end

    def link(href)
      element = OpenStruct.new('href' => href)
      element.text = 'Link text'
      AttachmentLink.new element
    end


  end

end
