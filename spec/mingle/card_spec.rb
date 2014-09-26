require_relative '../../lib/mingle/card'
require_relative '../helpers/http_stub'

module Mingle
  describe Card do

    let(:card_xml) { File.read(File.join(__dir__, '..', 'data', 'card.xml')) }
    let(:card) { Card.new(card_xml) }

    it "knows its description" do
      expect(card.description).to start_with '<p>'
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

  end
end
