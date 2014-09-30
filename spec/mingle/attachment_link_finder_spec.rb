require_relative '../../lib/mingle/attachment_link_finder'
module Mingle

  describe AttachmentLinkFinder do

    describe "finds links in html" do

        let(:card_xml) { File.read(File.join(__dir__, '..', 'data', 'card.xml')) }
        let(:description_html) { File.read(File.join(__dir__, '..', 'data', 'card_description.html')) }
        let(:card) { Card.new(card_xml) }

        before(:each) do
          @finder = AttachmentLinkFinder.new(card.description)
        end

        it "finds those links" do
          expect(@finder.attachment_links.size).to eq 2
        end

        it "knows the HTML document" do
          expect(@finder.card_description_document.to_html).to eq description_html
        end

    end


  end

end
