require 'logger'

require_relative 'mingle/logging'
require_relative 'mingle/credentials'
require_relative 'mingle/http_client'
require_relative 'mingle/api'
require_relative 'mingle/card'

module Mingle
  class LinkFixer
    include Logging

    def initialize(options)
      credentials = Credentials.from_csv(options[:credential_file])
      @http_client = HttpClient.new(credentials)
      prefix, suffix = options[:project_url].split('/projects/')
      @http_client.base_url = "#{prefix}/api/v2/projects/#{suffix}"
      @api = API.new(@http_client)
      Card.api = @api
    end

    def fix(options={dry_run: false})
      Card.all.each do |card|
        logger.debug "card ##{card.number} - #{card.name}"
      end
    end

  end
end
