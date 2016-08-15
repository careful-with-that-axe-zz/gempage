require "gempage/version"

require 'erb'
require 'fileutils'
require 'gempage/gemfile_processor'
require 'gempage/ruby_gem_info'
require 'gempage/configuration'
Gempage.send :extend, Gempage::Configuration

module Gempage
  class << self

    def generate(options = nil)
      result ? format(options) : puts(output_message)
    end

    def result
      return @result if defined? @result
      @result = gem_listing ? merge_gem_and_info : false
    end

    def gem_listing
      return @gem_listing if defined? @gem_listing
      @gem_listing = Gempage::GemfileProcessor.new(gemfile_path).gem_list
    end

    def merge_gem_and_info
      gem_listing.each_with_index do |listed_gem, index|
        ruby_gem_json = Gempage::RubyGemInfo.new(listed_gem[:name]).gem_json
        gem_listing[index].merge!(ruby_gem_json)
      end
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
        category_count = result.group_by{ |result| result[:category] }.length
        "Gem list generated for #{category_count} gem groups and #{result.length} gems to #{gempage_path}."
      else
        "There is no Gemfile to process, how odd..."
      end
    end

  end
end
