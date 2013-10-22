require "gempage/version"

require 'erb'
require 'fileutils'
require 'gempage/configuration'
require 'gempage/import'
Gempage.send :extend, Gempage::Configuration

module Gempage
  class << self

    def generate
      format(grouped_result)
    end

    def imported
      Gempage::Import::Importer.new(gemfile_path).gem_list
    end

    def grouped_result
      imported.group_by{ |result| result[:category] }
    end

    def format(result)
      # recursion situation if just within gemfile
      # Dir[File.join(File.dirname(__FILE__), '../public/*')].each do |path|
      #   FileUtils.cp_r(path, asset_gempage_path)
      # end

      Dir[File.join(File.dirname(__FILE__), '../public/application.css')].each do |path|
        FileUtils.cp_r(path, asset_gempage_path)
      end

      File.open(File.join(gempage_path, "index.html"), "w+") do |file|
        file.puts template('layout').result(binding)
      end
      puts output_message(result)
    end

    def template(name)
      ERB.new(File.read(File.join(File.dirname(__FILE__), '../views/', "#{name}.erb")))
    end

    def output_message(result)
      "Gem list generated for #{result.length} gem groups to #{gempage_path}."
    end

  end
end
