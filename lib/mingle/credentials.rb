module Mingle
  class Credentials

    attr_reader :access_key_id, :secret_access_key

    def self.from_csv(file)
      contents = File.read(file)
      access_key_id, secret_access_key = contents.split("\n")[1].split(',')
      self.new(access_key_id: access_key_id, secret_access_key: secret_access_key)
    end

    def initialize(values)
      @access_key_id = values.delete(:access_key_id) || raise("missing required value: access_key_id")
      @secret_access_key = values.delete(:secret_access_key) || raise("missing required value: secret_access_key")
    end

  end
end
