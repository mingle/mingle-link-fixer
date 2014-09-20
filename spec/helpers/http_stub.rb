class HttpStub

  def initialize(credentials=nil)
    @credentials = credentials
  end

  def respond_to(path, options)
    canned_responses[path] = options.delete(:with)
  end

  def get(relative_path, params)
    raise("Did not know how to respond to #{relative_path}") unless canned_responses[relative_path]
    OpenStruct.new(ok?: true, body: canned_responses[relative_path])
  end

  private

  def canned_responses
    @canned_responses ||= {}
  end

end
