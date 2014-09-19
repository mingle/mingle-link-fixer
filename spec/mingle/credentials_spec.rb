require_relative '../../lib/mingle/credentials'

module Mingle

  describe Credentials do

    let(:csv_filename) { File.join(__dir__, '..', 'data', 'credentials.csv') }

    it "can be instantiated from the mingle csv file" do
      credentials = Credentials.from_csv(csv_filename)
      expect(credentials.access_key_id).to eq 'abcd'
      expect(credentials.secret_access_key).to eq 'shh!'
    end

    it "can be instantiated with strings" do
      credentials = Credentials.new(access_key_id: 'abcd', secret_access_key: 'shh!')
      expect(credentials.access_key_id).to eq 'abcd'
      expect(credentials.secret_access_key).to eq 'shh!'
    end

  end

end
