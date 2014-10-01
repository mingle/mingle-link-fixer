module Mingle
  class Stats

    attr_accessor :total_cards_checked, :cards_without_attachments, :cards_without_links,
                  :cards_fixed, :problematic_cards

    def initialize
      @total_cards_checked = 0
      @cards_without_attachments = 0
      @cards_without_links = 0
      @problematic_cards = {}
      @cards_fixed = 0
      @start = Time.now
    end

    def duration_in_seconds
      Time.now - @start
    end

    SPACER = "=" * 80

    def to_pretty_string
      %{
        #{SPACER}
        SUMMARY

        Completed in #{duration_in_seconds} sec

        Total Cards Checked:         #{total_cards_checked}
        Cards Without Attachments:   #{cards_without_attachments}
        Cards Without Fixable Links: #{cards_without_links}

        Problematic Cards:           #{problematic_cards.size}
        #{'(specific errors can be seen if you set VERBOSE environment variable)' if problematic_cards.any?}

        Fixed Cards:                 #{cards_fixed}
        #{SPACER}
      }
    end

  end
end
