require "rabatt/version"

require 'rabatt/providers/base'
require 'rabatt/providers/adtraction'
require 'rabatt/providers/adrecord'

module Rabatt
  # Your code goes here...
def Rabatt(provider_name, options = {})
  class_name = provider_name.to_s.capitalize
  Object.const_get("Rabatt::Providers::#{class_name}").new
end
