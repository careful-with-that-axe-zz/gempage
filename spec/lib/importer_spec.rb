require 'spec_helper'

describe Gempage::Import::Importer do

  let(:data) { File.readlines(File.join(Dir.getwd, '/spec/fixtures/Gemfile')) }

  before :each do
    Gempage::Import::Importer.any_instance.stub(:puts) # Silencing display during tests
    File.stub(:read).with('Gemfilex') { StringIO.new(data) }
    @importer = Gempage::Import::Importer.new
  end

  it 'should process a bunch of gems' do
    gem_list = @importer.gem_list
  end

end
