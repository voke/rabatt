require 'json'
require 'open-uri'

# DOCS: https://www.double.net/api/publisher/v2/

module Rabatt
  module Providers
    class Double < Base

      ENDPOINT = 'https://www.double.net/api/publisher/v2/coupons/?format=json'

      attr_accessor :api_key

      def initialize(api_key = nil)
        self.api_key = api_key || ENV['DOUBLE_API_KEY']
        raise(ArgumentError, 'Missing ApiKey') unless self.api_key
      end

      def coupons
        res = open(ENDPOINT, 'Authorization' => "Token #{api_key}")
        JSON.parse(res.read).map do |data|
          p data
          Voucher.new.tap do |v|
            v.title = data['program_name']
            v.code = data['code']
            v.valid_from = data['start_date']
            v.expires_at = data['end_date']
            v.summary = data['description']
          end
        end
      end

    end
  end
end
