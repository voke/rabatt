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
        raise(ArgumentError, "Missing Webgains ApiKey") unless self.api_key
      end

      def vouchers(options = {})
        uri = URI.parse(URL)
        params = DEFAULT_PARAMS.merge(**options, key: api_key)
        uri.query = URI.encode_www_form(params)
        res = open(uri)
        JSON.parse(res.read).map do |data|
          Voucher.build do |v|
            v.uid = data['id']
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
