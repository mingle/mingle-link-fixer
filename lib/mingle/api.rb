require 'nokogiri'

require_relative 'logging'

module Mingle

  class API
    include Logging

    def initialize(http_client)
      @http_client = http_client
    end

    def get_card(number)
      @http_client.get("/cards/#{number}.xml").body
    end

    def execute_mql(mql)
      response = @http_client.get('/cards/execute_mql.xml', mql: mql)
      logger.debug(response.body)
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
