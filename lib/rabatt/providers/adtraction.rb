require 'uri'
require 'net/http'
require 'openssl'
require 'json'

# DOCS: https://api.adtraction.com/doc/affiliate/couponcodes.html

module Rabatt
  module Providers
    class Adtraction < Providers::Base

      ENDPOINT = 'https://api.adtraction.com/v1/affiliate/couponcodes'
      DEFAULT_MARKET = 'SE'

      attr_accessor :api_key

      def initialize(api_key = nil)
        self.api_key = api_key || ENV['ADTRACTION_API_KEY']
        raise(ArgumentError, 'Missing ApiKey') unless self.api_key
      end

      def parse(payload)
        payload.map do |data|
          Voucher.new.tap do |v|
            v.title = data['programName']
            v.code = data['offerCoupon']
            v.valid_from = data['validFrom']
            v.expires_at = data['validTo']
            v.summary = data['offerDescription']
            v.terms = data['offerTerms']
          end
        end
      end

      def coupons(channel_id, market: DEFAULT_MARKET)

        uri = URI.parse(ENDPOINT)
        header = { 'Content-Type' => 'application/json', 'X-Token' => self.api_key }

        data = { channelId: channel_id, market: market }

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Post.new(uri.request_uri, header)
        request.body = JSON.dump(data)

        response = http.request(request)
        payload = JSON.parse(response.body)

        if payload.is_a?(Hash) && payload.has_key?('error')
          raise(RequestError, payload['error'])
        else
          parse(payload)
        end

      end

    end
  end
end
