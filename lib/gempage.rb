require "gempage/version"

require 'erb'
require 'fileutils'
require 'gempage/configuration'
require 'gempage/import'
Gempage.send :extend, Gempage::Configuration

module Gempage
  class << self

    def generate(options = nil)
      format(grouped_result, options)
    end

    def result
      return @result if defined? @result
      Gempage::Import::Importer.new(gemfile_path).gem_list
    end

    def grouped_result
      return @grouped_result if defined? @grouped_result
      result.group_by{ |result| result[:category] }
    end

    def format(grouped_result, options)
      create_stylesheet('application', options)
      create_index(grouped_result)
      puts output_message(grouped_result, result)
    end

    def create_index(result)
      File.open(File.join(gempage_path, "index.html"), "w+") do |file|
        file.puts template('layout').result(binding)
      end
    end

    def create_stylesheet(name, options)
      custom_css_file = "custom/#{options[:colorscheme].to_s}.css"

      File.open(File.join(asset_gempage_path, "application.css"), "w+") do |file|
        file.puts File.readlines(File.join(File.dirname(__FILE__), '../public/application.css'))
        if options[:colorscheme] && File.exist?(File.join(File.dirname(__FILE__), '../public', custom_css_file))
          file.puts File.readlines(File.join(File.dirname(__FILE__), '../public', custom_css_file))
        end
      end
    end

    def template(name)
      ERB.new(File.read(File.join(File.dirname(__FILE__), '../views/', "#{name}.erb")))
    end

    def output_message(grouped_result, result)
      "Gem list generated for #{grouped_result.length} gem groups and #{result.length} gems to #{gempage_path}."
    end

  end
end
