require 'spec_helper'

describe Gempage::RubyGemInfo do
  let (:orginal_json_no_empty_strings) {
    { "name"=>"rails", "downloads"=>28773847, "version"=>"4.0.0",
      "info"=>"Ruby on Rails is a full-stack web framework optimized for programmer happiness and sustainable productivity.",
      "project_uri"=>"http://rubygems.org/gems/rails", "gem_uri"=>"http://rubygems.org/gems/rails-4.0.0.gem",
      "homepage_uri"=>"http://www.rubyonrails.org", "wiki_uri"=>"http://wiki.rubyonrails.org",
      "documentation_uri"=>"http://api.rubyonrails.org", "mailing_list_uri"=>"http://groups.google.com/group/rubyonrails-talk",
      "source_code_uri"=>"http://github.com/rails/rails" }
  }
  let (:orginal_json_empty_strings) {
    { "name"=>"httparty", "downloads"=>5888099, "version"=>"0.12.0",
      "info"=>"Makes http fun! Also, makes consuming restful web services dead easy.",
      "project_uri"=>"http://rubygems.org/gems/httparty", "gem_uri"=>"http://rubygems.org/gems/httparty-0.12.0.gem",
      "homepage_uri"=>"http://jnunemaker.github.com/httparty", "wiki_uri"=>nil, "documentation_uri"=>nil,
      "mailing_list_uri"=>nil, "source_code_uri"=>"http://github.com/jnunemaker/httparty" }
  }
  let (:rails_response_body) {
    "{\"name\":\"rails\",\"downloads\":28773847,\"version\":\"4.0.0\",
    \"info\":\"Ruby on Rails is a full-stack web framework optimized for programmer happiness and sustainable productivity.\",
    \"project_uri\":\"http://rubygems.org/gems/rails\",\"gem_uri\":\"http://rubygems.org/gems/rails-4.0.0.gem\",
    \"homepage_uri\":\"http://www.rubyonrails.org\",\"wiki_uri\":\"http://wiki.rubyonrails.org\",
    \"documentation_uri\":\"http://api.rubyonrails.org\",\"mailing_list_uri\":\"http://groups.google.com/group/rubyonrails-talk\",
    \"source_code_uri\":\"http://github.com/rails/rails\"}"
  }

  let (:httparty_response_body) {
    "{\"name\":\"httparty\",\"downloads\":5888099,\"version\":\"0.12.0\",
    \"info\":\"Makes http fun! Also, makes consuming restful web services dead easy.\",
    \"project_uri\":\"http://rubygems.org/gems/httparty\",\"gem_uri\":\"http://rubygems.org/gems/httparty-0.12.0.gem\",
    \"homepage_uri\":\"http://jnunemaker.github.com/httparty\",\"wiki_uri\":\"\",\"documentation_uri\":\"\",
    \"mailing_list_uri\":\"\",\"source_code_uri\":\"http://github.com/jnunemaker/httparty\"}"
  }

  it "should returns json with gem information" do
    stub_request(:any, "http://rubygems.org/api/v1/gems/rails.json").
                with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
                to_return(:status => 200, :body => rails_response_body, :headers => {})
    ruby_gem_json = Gempage::RubyGemInfo.new('rails').gem_json
    ruby_gem_json.should eql(orginal_json_no_empty_strings)
  end

  it "should returns json with gem information empty strings converted to nils" do
    stub_request(:any, "http://rubygems.org/api/v1/gems/httparty.json").
                with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
                to_return(:status => 200, :body => httparty_response_body, :headers => {})
    ruby_gem_json = Gempage::RubyGemInfo.new('httparty').gem_json
    ruby_gem_json.should eql(orginal_json_empty_strings)
  end

end
