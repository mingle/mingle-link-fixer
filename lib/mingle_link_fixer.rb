require 'logger'

require_relative 'mingle/logging'
require_relative 'mingle/credentials'
require_relative 'mingle/http_client'
require_relative 'mingle/api'
require_relative 'mingle/card'
require_relative 'mingle/historical_attachments'
require_relative 'mingle/attachment_link_finder'

module Mingle
  class LinkFixer
    include Logging

    def initialize(options)
      credentials = Credentials.from_csv(options[:credential_file])
      @http_client = HttpClient.new(credentials)
      prefix, suffix = options[:project_url].split('/projects/')
      @http_client.base_url = "#{prefix}/api/v2/projects/#{suffix}"
      @api = API.new(@http_client)
      @historical_attachments = HistoricalAttachments.new(options[:historical_attachments_folder])
      Card.api = @api
    end

    def fix(options={dry_run: false})
      Card.all.each do |card|
        logger.debug "Fixing Card ##{card.number} - #{card.name}"
        fixer = AttachmentLinkFinder.new(card.description)
        fixer.attachment_links.each do |attachment_link|
          mingle_wiki_syntax = attachment_link.rewrite(card, @historical_attachments)
          logger.debug "\treplacing link with #{mingle_wiki_syntax}"

        end
      end
    end

  end
end
