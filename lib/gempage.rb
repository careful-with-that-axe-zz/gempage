require 'erb'
require 'fileutils'
require "gemnasium/parser"

require "gempage/version"
require 'gempage/gem'
require 'gempage/ruby_gem'
require 'gempage/configuration'

Gempage.send :extend, Gempage::Configuration

module Gempage
  class << self

    def generate(options = nil)
      result ? format(options) : puts(output_message)
    end

    def result
      gem_listing.group_by(&:groups)
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
        gems << Gempage::Gem.new(dependency.name, groups: dependency.groups.sort, requirements: first_req)
      end

      gems
    end


    def gem_listing
      gemfile = File.exists?(gemfile_path) ? File.read(gemfile_path) : false
      process_gems(Gemnasium::Parser.gemfile(gemfile)) if gemfile
    end

    def format(options)
      create_index
      create_stylesheet(options)
      puts output_message
    end

    def create_index
      File.open(File.join(gempage_path, "index.html"), "w+") do |file|
        file.puts template('layout').result(binding)
      end
    end

    def template(name)
      ERB.new(File.read(File.join(File.dirname(__FILE__), '../views/', "#{name}.erb")))
    end

    def create_stylesheet(options)
      File.open(File.join(asset_gempage_path, "application.css"), "w+") do |file|
        file.puts File.readlines(File.join(File.dirname(__FILE__), "../public/application.css"))
        file.puts File.readlines(File.join(File.dirname(__FILE__), "../public/color-schemes/#{color_scheme_file(options)}.css"))
      end
    end

    def color_scheme_file(options)
      options && options[:colorscheme] && css_file_exists?(options[:colorscheme].to_s) ? options[:colorscheme].to_s : 'default'
    end

    def css_file_exists?(file_name)
      File.exist?(File.join(File.dirname(__FILE__), "../public/color-schemes/#{file_name}.css"))
    end

    def output_message
      if result
        "Gem list generated for #{result.length} gem groups and #{gem_listing.length} gems to #{gempage_path}."
      else
        "There is no Gemfile to process, how odd..."
      end
    end

  end
end
