require 'net/http'
require 'cgi'
require 'api_auth'

module Mingle
  class HttpClient
    include Logging

    attr_accessor :base_url

    def initialize(credentials)
      @credentials = credentials
    end

    def get(path, params={})
      url = File.join(base_url, path + to_url(params))
      logger.debug "HTTP GET #{url}"
      process(Net::HTTP::Get, url)
    end

    def post(path, params)
      url = url = File.join(base_url, path)
      logger.debug "HTTP POST #{url}"
      process(Net::HTTP::Post, url, {}, params[:body])
    end

    private

    def to_url(params)
      params.inject([]) do |memo, pair|
        memo.tap do |memo|
          key, value = *pair
          memo << "#{CGI.escape(key.to_s)}=#{CGI.escape(value.to_s)}"
        end
      end.join("&").tap { |params| return "?#{params}" unless params.empty? }
    end

    def process(request_class, url, headers={}, body=nil)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'

      request = request_class.new(uri.request_uri)
      request.body = body if body
      headers.each do |key, value|
        request[key] = value
      end

      ApiAuth.sign!(request, @credentials.access_key_id, @credentials.secret_access_key)

      response = http.request(request)
    end

  end
end
