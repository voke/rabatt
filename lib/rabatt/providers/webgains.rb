require 'open-uri'
require 'json'

module Rabatt
  module Providers
    class Webgains < Base

      URL = 'http://api.webgains.com/2.0/vouchers'

      DEFAULT_PARAMS = {
        networks: 'SE'
      }

      attr_accessor :api_key

      def initialize(api_key = nil)
        self.api_key = api_key || ENV['WEBGAINS_API_KEY']
        raise(ArgumentError, 'Missing ApiKey') unless self.api_key
      end

      def vouchers
        uri = URI.parse(URL)
        uri.query = URI.encode_www_form(DEFAULT_PARAMS.merge(key: api_key))
        res = open(uri)
        JSON.parse(res.read).map do |data|
          Voucher.build do |v|
            v.program = data['program_name']
            v.code = data['code']
            v.valid_from = Date.parse(data['startDate'])
            v.expires_on = Date.parse(data['expiryDate'])
            v.summary = data['description']
            v.url = data['destinationUrl']
            v.provider = :webgains
          end
        end
      end

    end
  end
end
