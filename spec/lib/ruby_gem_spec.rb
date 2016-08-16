require 'spec_helper'

describe Gempage::RubyGem do

  context "a RubyGem that has all values set" do
    before(:each) do
      rails_response_body = %Q{
        {"name":"rails","downloads":28773847,"version":"4.0.0",
        "info":"Ruby on Rails is a full-stack web framework optimized for programmer happiness and sustainable productivity.",
        "project_uri":"http://rubygems.org/gems/rails","gem_uri":"http://rubygems.org/gems/rails-4.0.0.gem",
        "homepage_uri":"http://www.rubyonrails.org","wiki_uri":"http://wiki.rubyonrails.org",
        "documentation_uri":"http://api.rubyonrails.org","mailing_list_uri":"http://groups.google.com/group/rubyonrails-talk",
        "source_code_uri":"http://github.com/rails/rails"}
      }

      stub_request(:get, "https://rubygems.org/api/v1/gems/rails.json").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'rubygems.org', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => rails_response_body, :headers => {})
    end

    it "sets the Gem name appropriately" do
      ruby_gem = Gempage::RubyGem.new("rails")
      expect(ruby_gem.name).to eql("rails")
    end

    it "sets all methods to appropriate Ruby Gem content" do
      ruby_gem = Gempage::RubyGem.new("rails")

      expect(ruby_gem.info).to eql("Ruby on Rails is a full-stack web framework optimized for programmer happiness and sustainable productivity.")
      expect(ruby_gem.homepage_uri).to eql("http://www.rubyonrails.org")
      expect(ruby_gem.documentation_uri).to eql("http://api.rubyonrails.org")
      expect(ruby_gem.source_code_uri).to eql("http://github.com/rails/rails")
    end
  end

  context "a RubyGem missing the documentation uri" do
    before(:each) do
      httparty_response_body = %Q{
        {"name":"httparty","downloads":5888099,"version":"0.12.0",
        "info":"Makes http fun! Also, makes consuming restful web services dead easy.",
        "project_uri":"http://rubygems.org/gems/httparty","gem_uri":"http://rubygems.org/gems/httparty-0.12.0.gem",
        "homepage_uri":"http://jnunemaker.github.com/httparty","wiki_uri":"","documentation_uri":"",
        "mailing_list_uri":"","source_code_uri":"http://github.com/jnunemaker/httparty"}
      }

      stub_request(:get, "https://rubygems.org/api/v1/gems/httparty.json").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'rubygems.org', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => httparty_response_body, :headers => {})
    end

    it "documentation_uri is an empty string" do
      ruby_gem = Gempage::RubyGem.new("httparty")

      expect(ruby_gem.name).to eql("httparty")
      expect(ruby_gem.info).to eql("Makes http fun! Also, makes consuming restful web services dead easy.")
      expect(ruby_gem.homepage_uri).to eql("http://jnunemaker.github.com/httparty")
      expect(ruby_gem.documentation_uri).to eql("")
      expect(ruby_gem.source_code_uri).to eql("http://github.com/jnunemaker/httparty")
    end
  end
end
