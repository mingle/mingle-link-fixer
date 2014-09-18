require_relative '../../lib/mingle/card'

module Mingle
  describe Card do

    let(:card_xml) { File.read(File.join(__dir__, '..', 'data', 'card.xml')) }

    it "knows its description" do
        card = Card.new(card_xml)
        expect(card.description).to start_with '<p>'
    end

  end
end
