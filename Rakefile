require "bundler/gem_tasks"
require "rspec/core/rake_task"

namespace :assets do
  desc "Compiles all assets"
  task :compile do
    puts "Compiling assets"
    require 'sprockets'
    require 'fileutils'
    assets = Sprockets::Environment.new
    assets.append_path 'assets/stylesheets'
    assets['application.css'].write_to('public/application.css')
    color_scheme_files = Dir.entries("assets/stylesheets/color-schemes/")
    color_scheme_files.each do |color_scheme_file|
      file_name = color_scheme_file.to_s.match(/(.+)\.scss$/)
      if file_name
        assets["color-schemes/#{color_scheme_file}"].write_to("public/color-schemes/#{file_name[1]}.css")
      end
    end
  end
end

RSpec::Core::RakeTask.new

task :default => :spec
task :test => :spec