require 'fileutils'
require "gemnasium/parser"

module Gempage
  class GemfileProcessor
    attr_reader :gem_list

    def initialize(gemfile_path)
      @gemfile_path = gemfile_path
      @gem_list = gem_list
    end

    def gem_list
      process_gems(Gemnasium::Parser.gemfile(gemfile_lines)) if gemfile_lines
    end

    private

    def gemfile_lines
      return @gemfile_lines if defined? @gemfile_lines
      @gemfile_lines = File.exists?(@gemfile_path) ? File.read(@gemfile_path) : false
    end

    def process_gems(data)
      gems = []
      data.dependencies.each do |dependency|
        requirements = dependency.requirement.as_list
        first_req = requirements.nil? || requirements.first == ">= 0" ? nil : requirements.first
        if first_req
          first_req = first_req.gsub(/^\=\s/, '')
          first_req = "'#{first_req}'"
        end
        gems << { name: dependency.name, category: dependency.groups.sort, configuration: first_req }
      end
      gems
    end
  end
end
