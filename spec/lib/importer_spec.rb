require 'spec_helper'
require 'fixtures/gem_list_fixture'

describe Gempage::Import::Importer do

  before :each do
    Gempage::Import::Importer.any_instance.stub(:puts) # Silencing display during tests
    gemfile_path = File.join(Gempage.root, '/spec/fixtures/Gemfile')
    @importer = Gempage::Import::Importer.new(gemfile_path)
  end

  xit 'should process a bunch of gems'

end
