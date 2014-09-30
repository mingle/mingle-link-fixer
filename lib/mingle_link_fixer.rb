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

    class Stats

      attr_accessor :total_cards_checked, :cards_without_attachments, :cards_without_links,
                    :cards_fixed, :problematic_cards

      def initialize
        @total_cards_checked = 0
        @cards_without_attachments = 0
        @cards_without_links = 0
        @problematic_cards = {}
        @fixed_cards = 0
      end

    end

    def initialize(options)
      @http_client = HttpClient.new(options[:username], options[:password])
      @http_client.base_url = options[:project_url].gsub('/projects/', '/api/v2/projects/')
      @api = API.new(@http_client)
      @historical_attachments = HistoricalAttachments.new(options[:historical_attachments_folder])
      Card.api = Attachment.api = @api
    end

    def fix(options={})
      stats = Stats.new
      options = {dry_run: false, starting_card: '1'}.merge(options)
      logger.info "running #{self.class} (dry_run: #{options[:dry_run]}, verbose_logging: #{VERBOSE})"
      Card.all(starting_with: options[:starting_card], limit: options[:limit]).each do |card|
        stats.total_cards_checked += 1
        begin
          if card.attachments.empty?
            logger.debug "skipping Card ##{card.number} because it has no attachments."
            stats.cards_without_attachments += 1
            next
          end
          finder = AttachmentLinkFinder.new(card.description)

          if finder.attachment_links.empty?
            logger.info "no attachment links present"
            stats.cards_without_links += 1
            next
          end

          logger.info "fixing #{finder.attachment_links.size} links"

          finder.attachment_links.each do |attachment_link|
            attachment_link.rewrite!(card, @historical_attachments)
          end

          html_document = finder.card_description_document
          card.description = html_document.to_html

          if options[:dry_run]
              logger.info("(skipped saving card because dry_run is enabled)")
          else
              card.save!
              stats.cards_fixed += 1
          end

        rescue => e
          logger.error "Unable to fix Card ##{card.number} because of error: #{e.message}"
          stats.cards_with_problematic_links[card.number] = e.message
          logger.debug e.backtrace.join("\n")
        end
      end

      logger.info "Completed in Xsec"
      # stats
    end

  end
end
