require 'fileutils'

module Gempage
  class GemfileProcessor
    attr_reader :gem_list

    def initialize(gemfile_path)
      @gemfile_path = gemfile_path
      @gem_list = gem_list
    end

    def gem_list
      process_gems(normalize(gemfile_lines))
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

    def get_group(line)
      group = line.match(/^group\s+(.+)\sdo$/)
      group ? group[1] : 'all'
    end

    def gem_details(line, group)
      gem_pieces = line.match(/^gem\s'([\w|-]+)',?\s?(.*)/)
      configuration = gem_pieces[1] if gem_pieces[1] && gem_pieces[1].strip.length != 0
      gem_pieces ? { 'name' => gem_pieces[1], 'category' => group, 'configuration' => configuration } : nil
    end

  end
end
