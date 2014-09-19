require 'ostruct'
require_relative '../../lib/mingle/attachment_link'

module Mingle

  describe AttachmentLink do

    let(:card) { }

    let(:historical_stub) do

    end

    # it "knows how to rewrite absolute links" do
    #   link = link('http://mingle.osito.org/projects/bonito/attachments/7777')
    #   expect(link.rewrite(card, historical_stub)).to eq '[[Link text|#123/doc.pdf]]'
    # end


    def link(href)
      element = OpenStruct.new('href' => href)
      element.text = 'Link text'
      AttachmentLink.new element
    end


  end

end
