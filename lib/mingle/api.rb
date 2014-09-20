require 'nokogiri'

module Mingle

  class API

    def initialize(credentials, http_client)
      @http_client = http_client
      @http_client.authenticate_with(credentials)
    end

    def execute_mql(mql)
      response = @http_client.get('/cards/execute_mql.xml', mql: mql)
      if response.ok?
        Nokogiri::XML.parse(response.body).search('result').inject([]) do |results, result|
          result_hash = result.children.inject({}) do |hash, child|
            unless Nokogiri::XML::Text === child
              hash[child.name] = child.text
            end
            hash
          end
          results << result_hash
        end
      end
    end


  end

end
