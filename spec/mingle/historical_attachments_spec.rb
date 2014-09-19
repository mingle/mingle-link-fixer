require_relative '../../lib/mingle/historical_attachments'

module Mingle

  describe HistoricalAttachments do

    let(:attachments) { HistoricalAttachments.new(File.join(__dir__, '..', 'data', 'extracted_export')) }

    it "knows how many there are" do
      expect(attachments.size).to eq 6
    end

    it "can find by id" do
      expect(attachments.find_by_id(7412).filename).to eq 'intercom-invoice.pdf'
    end

  end

end
