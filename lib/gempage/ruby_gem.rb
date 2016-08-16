require 'json'

module Gempage
  class RubyGem
    class FetchError < StandardError; end

    GITHUB_LINK_PATTERN = /github\.com/

    attr_accessor :name

    def initialize(name)
      @name = name
    end

    def info
      rubygem_content["info"]
    end

    def homepage_uri
      rubygem_content["homepage_uri"]
    end

    def documentation_uri
      documentation_uri = rubygem_content["documentation_uri"]
      documentation_uri = nil if documentation_uri == source_code_uri
      documentation_uri
    end

    def source_code_uri
      source_code_uri = rubygem_content["source_code_uri"]
      source_code_uri = homepage_uri if !source_code_uri && homepage_uri.match(GITHUB_LINK_PATTERN)
      source_code_uri
    end

    def error
      nil
    end

    private

    def rubygem_json_url
      "https://rubygems.org/api/v1/gems/#{name}.json"
    end

    def rubygem_content
      @rubygem_content ||= begin
        response_body = fetch_http(rubygem_json_url)
        JSON.parse(response_body)
      end
    end

    def fetch_http(url, request_max = 5)
      raise FetchError.new("Too many redirects #{url}") if request_max <= 0

      response = Net::HTTP.get_response(URI(url))

      case response.code.to_i
      when 200
        response.body
      when 301..303
        fetch_http(URI(response["location"]), request_max - 1)
      else
        raise FetchError.new("Bad response #{url}: #{response.message} #{response.code}", )
      end
    end
  end
end
