require "gempage/version"

require 'erb'
require 'fileutils'
require 'gempage/configuration'
require 'gempage/import'
Gempage.send :extend, Gempage::Configuration
Gempage.send :extend, Gempage::Import

module Gempage
  class << self

    def run_format
      format(grouped_result)
    end

    def grouped_result
      import.group_by{ |result| result[:category] }
    end

    def format(result)
      Dir[File.join(File.dirname(__FILE__), '../public/*')].each do |path|
        FileUtils.cp_r(path, asset_gempage_path)
      end

      File.open(File.join(gempage_path, "index.html"), "w+") do |file|
        file.puts template('layout').result(binding)
      end
    end

    def template(name)
      ERB.new(File.read(File.join(File.dirname(__FILE__), '../views/', "#{name}.erb")))
    end

    def output_message(result)
      "Gem list generated for #{result.length} gem groups to #{gempage_path}."
    end

  end
end
