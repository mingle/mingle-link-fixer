require_relative '../../lib/mingle/card'

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

  end
end
