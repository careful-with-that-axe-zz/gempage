include Forwardable

module Gempage
  class Gem
    extend Forwardable

    attr_accessor :name, :groups, :requirements, :error

    def_delegators :@ruby_gem, :info, :homepage_uri, :documentation_uri, :source_code_uri, :error

    def initialize(name, groups:, requirements:)
      @name = name
      @groups = groups
      @requirements = requirements
      @ruby_gem = Gempage::RubyGem.new(name)
      @error = nil
    end
  end
end
