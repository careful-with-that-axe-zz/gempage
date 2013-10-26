require 'fileutils'
require 'json'

module Gempage::Import
  class Importer

    attr_reader :gem_list

    def initialize(gemfile_path)
      @gemfile_path = gemfile_path
      @gem_list = gem_list
    end

    def gem_list
      if gemfile_lines
        gems = process_gems(normalize(gemfile_lines))
        final_gems = []
        gems.each do |gem_listing|
          final_gems << add_rubygem_content(gem_listing) if find_gem(gem_listing[:name])
        end
      else
        puts "There is no Gemfile to process... how odd."
      end
    end

    private

    def gemfile_lines
      File.readlines(@gemfile_path) if File.exists? @gemfile_path
    end

    def normalize(gemfile)
      # Strip white space, keep only lines starting with gem, group
      # or end, normalize to single quotes, remove trailing comments
      gemfile.map { |x| x.strip.gsub(/"/,"'") }
             .reject { |x| x.empty? || !x.match(/^(gem|group|end)/) }
             .map { |x| x.gsub(/\s?#.*$/, '') }
    end

    # The heart of the system that parses through the Gemfile
    # The only lines left are ones that start with gem group or end

    def process_gems(data, group = 'all', gems = [])
      data.each_with_index do |line, index|
        if line.match(/^gem\s/)
          gem_detail = gem_details(line, group)
          gems << gem_detail if gem_detail
        else
          group = get_group(line)
          return process_gems(data[(index + 1)..-1], group, gems) unless group == 'all'
        end
      end
      gems
    end

    # The only lines left are ones that start with gem group or end
    # The only time you get to this method is if it is group or end
    def get_group(line)
      group = line.match(/^group\s+(.+)\sdo$/)
      group ? group[1] : 'all'
    end

    def gem_details(line, group)
      gem_pieces = line.match(/^gem\s'([\w|-]+)',?\s?(.*)/)
      gem_pieces ? { name: gem_pieces[1], category: group, configuration: gem_pieces[2] } : nil
    end

    # The snagging gem details from RubyGems.org part of the system

    def find_gem(name)
      rubygems_content = response_body(rubygem_url(name))
      JSON.parse(rubygems_content) if rubygems_content
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

    def rubygem_error(error_code = nil)
      error_message = "There was an issue getting stuff back from RubyGems."
      error_message += " Error code: #{error_code}" if error_code
      '{ "error":"' + error_message + '" }'
    end

    def rubygem_url(name)
      "https://rubygems.org/api/v1/gems/#{name}.json"
    end

    # The final creation of the gem listing array of hashed ruby gem content

    def add_rubygem_content(gem_listing)
      rubygem = find_gem(gem_listing[:name])
      documentation_uri = get_documentation_uri(rubygem['documentation_uri'], rubygem['homepage_uri'])
      source_code_uri = get_source_code_uri(rubygem['source_code_uri'], rubygem['homepage_uri'])
      homepage_uri = get_homepage_uri(rubygem['homepage_uri'])
      if rubygem
        gem_listing[:downloads] = rubygem['downloads']
        gem_listing[:version] = rubygem['version']
        gem_listing[:authors] = rubygem['authors']
        gem_listing[:info] = rubygem['info']
        gem_listing[:documentation_uri] = documentation_uri
        gem_listing[:source_code_uri] = source_code_uri
        gem_listing[:homepage_uri] = homepage_uri
        gem_listing[:error] = rubygem['error']
        gem_listing
      else
        puts "None such #{name} gem... #{name} will not be in the Gem Reference"
        false
      end
    end

    def get_homepage_uri(homepage_uri)
      homepage_uri && homepage_uri != '' ? homepage_uri : nil
    end

    def get_documentation_uri(documentation_uri, source_code_uri)
      documentation_uri && documentation_uri != '' && documentation_uri != source_code_uri ? documentation_uri : nil
    end

    def get_source_code_uri(source_code_uri, homepage_uri)
      source_code_uri && source_code_uri != '' ? source_code_uri : nil
      !source_code_uri && homepage_uri && homepage_uri.match(/github\.com/) ? homepage_uri : source_code_uri
    end
  end
end
