require_relative '../../lib/mingle/attachment_link_finder'
module Mingle

  describe AttachmentLinkFinder do

    describe "finds links in html" do

        let(:card_description) { File.read(File.join(__dir__, '..', 'data', 'card.xml')) }

        before(:each) do
          @finder = AttachmentLinkFinder.new(card_description)
        end

        it "finds those links" do
          expect(@finder.attachment_links.size).to eq 2
        end

    end


  end

end
