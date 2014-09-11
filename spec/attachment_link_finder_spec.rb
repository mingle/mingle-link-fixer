require_relative '../lib/mingle/attachment_link_finder'
module Mingle

  describe AttachmentLinkFinder do

    describe "finds links in html" do

        let(:card_description) { "<h1>Hello</h1>" }

        before(:each) do
          @finder = AttachmentLinkFinder.new(card_description)
        end

        it "finds those links" do
          expect(@finder).to_not be_nil
        end

    end


  end

end
