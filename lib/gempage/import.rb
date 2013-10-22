require 'fileutils'
require 'json'

module Gempage::Import
  class Importer

    attr_reader :gem_list

    def initialize(gemfile_path)
      @gemfile_path = gemfile_path
      @gem_list = gem_list
    end

    def gemfile_lines
      File.readlines(@gemfile_path) if File.exists? @gemfile_path
    end

    def gem_list
      if gemfile_lines
        gems = process_gems(normalize(gemfile_lines))
        gem_array = []
        gems.each do |group, values|
          values.each do |t,r|
            gem_name = t.keys.first
            gem_config = t.values.first
            group_name = group.strip if group.is_a? String
            group_name = group.join(', ') if group.is_a? Array
            gem_info = create_rubygem(gem_name, group_name, gem_config)
            gem_array << gem_info if gem_info
          end
        end
        gem_array
      else
        puts "There is no Gemfile to process... how odd."
      end
    end

    def find_gem(name)
      url = "https://rubygems.org/api/v1/gems/#{name}.json"
      JSON.parse(response_body(url)) if response_body(url)
    end

    def response_body(url)
      request = Net::HTTP.new URI(url).host
      response = request.request_get URI(url).path
      response.code.to_i == 200 ? response.body : false
    end

    def create_rubygem(name, group, gem_config)
      rubygem = find_gem(name)
      if rubygem
        rubygem_hash = {
          name: name,
          category: group,
          configuration: gem_config,
          downloads: rubygem['downloads'],
          version: rubygem['version'],
          authors: rubygem['authors'],
          info: rubygem['info'],
          documentation_uri: get_documentation_uri(rubygem['documentation_uri'], rubygem['homepage_uri']),
          source_code_uri: get_source_code_uri(rubygem['source_code_uri'], rubygem['homepage_uri']),
          homepage_uri: get_homepage_uri(rubygem['homepage_uri'])
        }
      else
        puts "None such #{name} gem... #{name} will not be in the Gem Reference"
      end
      rubygem_hash
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

    def normalize(gemfile)
      # Strip white space, keep only lines starting with gem, group
      # or end, normalize to single quotes, remove trailing comments
      gemfile.map { |x| x.strip.gsub(/"/,"'") }
             .reject { |x| x.empty? || !x.match(/^(gem|group|end)/) }
             .map { |x| x.gsub(/\s?#.*$/, '') }
    end

    def set_group_section(line)
      line.sub(/^group /, '').sub(/ do$/, '').gsub(':', '').split(/,\s*/)
    end

    def add_gem(gems, section, line)
      gems[section] = [] unless gems[section]
      gems[section] << gem_details(line)
    end

    def gem_details(line)
      gem_pieces = line.match(/^gem\s'([\w|-]+)',?\s?(.*)/)
      gem_pieces ? { gem_pieces[1] => gem_pieces[2] } : nil
    end

    def process_gems(data, section = 'all', gems = {})
      data.each_with_index do |line, index|
        if line.match(/^gem\s/)
          add_gem(gems, section, line)
        else
          if line.match(/^group/)
            section = set_group_section(line)
            return process_gems(data[(index + 1)..-1], section, gems)
          else line.match(/^end/)
            section = 'all'
          end
        end
      end
      gems
    end
  end
end
