require_relative '../../lib/mingle/attachment'
require_relative '../../lib/mingle/api'
require_relative '../helpers/http_stub'

module Mingle

  describe Attachment do


    it "has a filename" do
      attachment = Attachment.new('osito.txt')
      expect(attachment.filename).to eq 'osito.txt'
    end

    context "with stubbed api" do

      let(:http_stub) { HttpStub.new }
      let(:api) { API.new(http_stub) }


      before(:each) { Attachment.api = api }

      it "can find all by card number" do
        http_stub.respond_to '/cards/88/attachments.xml', with:<<-XML
<attachments type="array">
  <attachment>
    <url>/attachments/5c6cc8db843c3276159c2d8ed400da58/88/zorro.pdf</url>
    <file_name>zorro.pdf</file_name>
  </attachment>
  <attachment>
    <url>/attachments/2dddd8db843c3276159c2d8ed400da58/88/osito.png</url>
    <file_name>osito.png</file_name>
  </attachment>
</attachments>
XML
        attachments = Attachment.find_all_by_card_number(88)
        expect(attachments.size).to eq 2

      end


    end




  end


end
