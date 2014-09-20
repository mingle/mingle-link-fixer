require_relative '../../lib/mingle/api'
require_relative '../helpers/http_stub'

module Mingle

  describe API do

    let(:credentials) { Credentials.new(access_key_id: 'osito', secret_access_key: 'qAeODM3Px46uzuuZBiG8vhh9oioShRzYwO9oSSLxAEU')}

    let(:http_client) { HttpStub.new }

    let(:api) { API.new(credentials, http_client) }

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
