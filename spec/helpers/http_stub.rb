require 'ostruct'

class HttpStub

  def initialize(credentials=nil)
    @credentials = credentials
  end

  def respond_to(path, options)
    canned_responses[path] = options.delete(:with)
  end

  def post(path, params)
    number = if path =~ /cards\/(\d+)\.xml/
      $1.to_i
    end
    respond_to(path, with:<<-XML)
<?xml version="1.0" encoding="UTF-8"?>
<card>
  <name>name of #{number}</name>
  <description>#{params[:description]}</description>
  <number type="integer">#{number}</number>
</card>
XML
  end

  def get(relative_path, params={})
    raise("Did not know how to respond to #{relative_path}") unless canned_responses[relative_path]
    OpenStruct.new(ok?: true, body: canned_responses[relative_path])
  end

  private

  def canned_responses
    @canned_responses ||= {}
  end

end
