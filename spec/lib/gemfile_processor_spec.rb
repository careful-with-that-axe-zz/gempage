require 'spec_helper'

describe Gempage::GemfileProcessor do
  let (:processed_gemfile) {
    [ {name: "rails", category: [:default], configuration: "'3.2.14'"},
      {name: "mysql2", category: [:default], configuration: nil},
      {name: "higgly", category: [:default], configuration: nil},
      {name: "thin", category: [:default], configuration: nil},
      {name: "resque", category: [:default], configuration: nil},
      {name: "httparty", category: [:default], configuration: nil},
      {name: "json", category: [:default], configuration: nil},
      {name: "sanitize", category: [:default], configuration: nil},
      {name: "pg", category: [:production], configuration: nil},
      {name: "turbo-sprockets-rails3", category: [:assets], configuration: nil},
      {name: "uglifier", category: [:assets], configuration: "'>= 1.0.3'"},
      {name: "sass-rails", category: [:assets], configuration: "'~> 3.2.3'"},
      {name: "coffee-rails", category: [:assets], configuration: "'~> 3.2.1'"},
      {name: "better_errors", category: [:development], configuration: nil},
      {name: "binding_of_caller", category: [:development], configuration: nil},
      {name: "jazz_hands", category: [:development, :test], configuration: nil},
      {name: "quiet_assets", category: [:development, :test], configuration: nil},
      {name: "rspec-rails", category: [:test], configuration: nil},
      {name: "rspec-mocks", category: [:test], configuration: nil},
      {name: "email_spec", category: [:test], configuration: nil},
      {name: "webmock", category: [:test], configuration: nil}]
  }

  it 'should process a bunch of gems' do
    gemfile_path = File.join(Gempage.root, '/spec/fixtures/Gemfile')
    gem_listing = Gempage::GemfileProcessor.new(gemfile_path).gem_list
    gem_listing.should eql(processed_gemfile)
  end

  it 'should return nil if there is no Gemfile' do
    gemfile_path = File.join(Gempage.root, '/spec/fixtures/nonesuch_Gemfile')
    gem_listing = Gempage::GemfileProcessor.new(gemfile_path).gem_list
    gem_listing.should eql(nil)
  end

end
