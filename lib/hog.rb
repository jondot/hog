require "hog/version"
require 'json'
require 'hog/tuple'
require 'hog/field'
require 'hog/utils'
require 'hog/pig_schema'
require 'hog/hive_schema'
require 'hog/udf_schema'

module Hog
  class << self
    include Hog::Utils
  end

  def self.tuple(name, &block)
    Tuple.new(name, block)
  end
end




