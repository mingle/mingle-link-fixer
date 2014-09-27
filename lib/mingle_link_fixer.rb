require 'logger'

require_relative 'mingle/logging'
require_relative 'mingle/http_client'
require_relative 'mingle/api'
require_relative 'mingle/card'
require_relative 'mingle/historical_attachments'
require_relative 'mingle/attachment_link_finder'

module Mingle
  class LinkFixer
    include Logging

    def initialize(options)
      @http_client = HttpClient.new(options[:username], options[:password])
      prefix, suffix =
      @http_client.base_url = options[:project_url].gsub('/projects/', '/api/v2/projects/')
      @api = API.new(@http_client)
      @historical_attachments = HistoricalAttachments.new(options[:historical_attachments_folder])
      Card.api = Attachment.api = @api
    end

    def fix(options={dry_run: false})
      require('pry')
      binding.pry
      Card.all.each do |card|
        begin
          if card.attachments.empty?
            logger.debug "skipping Card ##{card.number} because it has no attachments."
            next
          end
          fixer = AttachmentLinkFinder.new(card.description)

          if fixer.attachment_links.empty?
            logger.info "no attachment links present"
            next
          end

          logger.info "fixing #{fixer.attachment_links.size} links"
          fixer.attachment_links.each do |attachment_link|
            mingle_wiki_syntax = attachment_link.rewrite(card, @historical_attachments)
            logger.debug "replacing link with #{mingle_wiki_syntax}"


            unless options[:dry_run]

            else
              logger.debug "[dry-run] so not doing any actual change"
            end
          end
        rescue => e
          logger.error "Unable to fix Card ##{card.number} because of error: #{e.message}"
          logger.debug e.backtrace.join("\n")
        end
      end
    end

  end
end
