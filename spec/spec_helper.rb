$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rabatt'

require "minitest/autorun"
require "mocha"
require "minitest/reporters"
require 'webmock/minitest'

Minitest::Reporters.use!

class Fixture

  def self.fixtures_path
    File.expand_path("../fixtures/*", __FILE__)
  end

  def self.read(name)
    absolute_path = fixtures.find do |path|
      File.basename(path, '.*').eql?(name.to_s)
    end
    if absolute_path
      File.new(absolute_path)
    else
      raise("Missing fixture: #{name.inspect}")
    end
  end

  def self.fixtures
    Dir.glob(fixtures_path)
  end

end
