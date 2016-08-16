require 'spec_helper'

describe Gempage::Gem do
  before(:each) do
    ruby_gem_json_double = double(
      name: "httparty",
      info: "Makes http fun! Also, makes consuming restful web services dead easy.",
      homepage_uri: "http://jnunemaker.github.com/httparty",
      documentation_uri: "",
      source_code_uri: "http://github.com/jnunemaker/httparty",
      error: ""
    )
    allow(Gempage::RubyGem).to receive(:new).with("httparty").and_return(ruby_gem_json_double)
  end

  it "turns all arguments into public methods" do
    httparty_gem = Gempage::Gem.new("httparty", groups: [:default], requirements: ["~> 3.2.3"])

    expect(httparty_gem.name).to eql("httparty")
    expect(httparty_gem.groups).to eql([:default])
    expect(httparty_gem.requirements).to eql(["~> 3.2.3"])
  end

  it "delegates methods to RubyGem" do
    httparty_gem = Gempage::Gem.new("httparty", groups: [:default], requirements: ["~> 3.2.3"])

    expect(httparty_gem.info).to eql("Makes http fun! Also, makes consuming restful web services dead easy.")
    expect(httparty_gem.homepage_uri).to eql("http://jnunemaker.github.com/httparty")
    expect(httparty_gem.documentation_uri).to eql("")
    expect(httparty_gem.source_code_uri).to eql("http://github.com/jnunemaker/httparty")
    expect(httparty_gem.error).to eql("")
  end
end
