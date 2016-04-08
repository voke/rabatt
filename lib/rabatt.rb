require "rabatt/version"

require 'rabatt/voucher'
require 'rabatt/providers/base'
require 'rabatt/providers/adtraction'
require 'rabatt/providers/double'
require 'rabatt/providers/adrecord'

module Rabatt
  RequestError = Class.new(StandardError)
end

def Rabatt(provider_name, options = {})
  class_name = provider_name.to_s.capitalize
  Object.const_get("Rabatt::Providers::#{class_name}").new
end
