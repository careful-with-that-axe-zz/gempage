require "bundler/gem_tasks"
require "rspec/core/rake_task"

namespace :assets do
  desc "Compiles all assets"
  task :compile do
    puts "Compiling assets"
    require 'sprockets'
    assets = Sprockets::Environment.new
    assets.append_path 'assets/stylesheets'
    assets['application.css'].write_to('public/application.css')
    assets['pastels.scss'].write_to('public/colorschemes/pastels.css')
    assets['random.scss'].write_to('public/colorschemes/random.css')
  end
end

RSpec::Core::RakeTask.new

task :default => :spec
task :test => :spec