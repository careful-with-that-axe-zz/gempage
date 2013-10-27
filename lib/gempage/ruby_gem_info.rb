require 'json'

module Gempage
  class RubyGemInfo

    # The snagging gem details from RubyGems.org part of the system

    attr_reader :gem_json

    def initialize(gem_name)
      @gem_name = gem_name
      @gem_json = gem_json
    end

    def gem_json
      process_uris(process_empty_strings(get_gem_json))
    end

    private

    def get_gem_json
      JSON.parse(response_body(rubygem_url))
    end

    def response_body(url)
      begin
        request = Net::HTTP.new URI(url).host
        response = request.request_get URI(url).path
        response.code.to_i == 200 ? response.body : rubygem_error(response.code.to_s)
      rescue StandardError
        rubygem_error
      end
    end

    def rubygem_url
      "https://rubygems.org/api/v1/gems/#{@gem_name}.json"
    end

    def rubygem_error(error_code = nil)
      error_message = error_code ? error_code : "Issue with RubyGems"
      '{ "error":"' + error_message + '" }'
    end

    def process_empty_strings(gem_json)
      gem_json.each{ |key, value| gem_json[key] = nil if value.kind_of?(String) && value.strip.length == 0 }
    end

    def process_uris(gem_json)
      gem_json['source_code_uri'] = get_source_code_uri(gem_json['source_code_uri'], gem_json['homepage_uri'])
      gem_json
    end

    def get_source_code_uri(source_code_uri, homepage_uri)
      !source_code_uri && homepage_uri && homepage_uri.match(/github\.com/) ? homepage_uri : source_code_uri
    end

  end
end
