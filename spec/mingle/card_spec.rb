require_relative '../../lib/mingle/card'
require_relative '../helpers/http_stub'

module Mingle
  describe Card do

    let(:card_xml) { File.read(File.join(__dir__, '..', 'data', 'card.xml')) }
    let(:card) { Card.new(card_xml) }

    context "description attribute" do
      it "can be read" do
        expect(card.description).to start_with '<p>'
      end

      it "extracts the html fragment when setting with a full HTML document" do
        card.description = %{<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
          <html>
            <body>
              <p>[[Link text|#123/pomeranian.jpg]]</p>
            </body>
          </html>
        }
        expect(without_whitespace(card.description)).to eq %{<p>[[Link text|#123/pomeranian.jpg]]</p>}
      end
    end



    it "knows its number" do
      expect(card.number).to eq 1
    end

    it "knows its name" do
      expect(card.name).to eq "first"
    end

    it "can serialize itself to xml" do
      expect(card.to_xml.strip).to include("<?xml version=\"1.0\"?>\n<card>\n  <description>&lt;p&gt;&amp;nbsp;&lt;/p&gt;\n\n&lt;p&gt;Do you see any Teletubbies in here?")
    end

    context "with stubbed api" do
      let(:http_client) { HttpStub.new }
      let(:api) { API.new(http_client) }

      before(:each) do
        Card.api = api
        http_client.respond_to('/cards/1.xml', with: card_xml)
      end

      describe "#save!" do

        it "persists to mingle" do
          card.description = "I have been modified"
          card.save!
          reloaded_card = Card.find_by_number(card.number)
          expect(reloaded_card.description).to eq card.description
        end
      end

    end

    private

    def without_whitespace(string)
      string.gsub("\t", "").gsub("\n", "").strip
    end

  end
end
