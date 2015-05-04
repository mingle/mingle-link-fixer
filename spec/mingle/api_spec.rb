require_relative '../../lib/mingle/api'
require_relative '../../lib/mingle/card'
require_relative '../helpers/http_stub'

module Mingle

  describe API do

    let(:http_client) { HttpStub.new }
    let(:api) { API.new(http_client) }
    let(:card_xml) { File.read(File.join(__dir__, '..', 'data', 'card.xml')) }
    let(:card) { Card.new(card_xml) }

    context "#save_card" do
      it "submits #to_xml" do
        card.description = "xyz"
        api.save_card(card)
        expect(api.get_card(card.number)).to eq(card.to_xml)
      end
    end

    it "can execute mql" do

      http_client.respond_to('/cards/execute_mql.xml', with: <<-XML)
        <?xml version="1.0" encoding="UTF-8"?>
        <results type="array">
          <result>
            <max_number>999</max_number>
          </result>
        </results>
      XML

      expect(api.execute_mql('SELECT MAX(number)')).to eq [{'max_number' => '999'}]
    end

  end

end
