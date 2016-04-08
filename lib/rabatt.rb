require "rabatt/version"

require 'rabatt/voucher'

module Rabatt

  RequestError = Class.new(StandardError)
  MissingProviderError = Class.new(StandardError)

  def self.providers
    @@providers ||= {}
  end

  def self.register(provider_klass)
    providers[provider_klass.identifier] = provider_klass
  end

end

require 'rabatt/providers'

def Rabatt(provider_name)
  provider_class = Rabatt.providers.fetch(provider_name.to_s) do |missing_name|
    raise(Rabatt::MissingProviderError, "Provider #{missing_name.inspect} does not exist!")
  end
  provider_class.new
end
