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

      def vouchers_by_channel(channel_id)
        vouchers.select do |voucher|
          voucher.payload['tracking'].find do |entry|
            entry['channel'] == channel_id
          end
        end
      end

      def vouchers
        res = open(ENDPOINT, 'Authorization' => "Token #{api_key}")
        JSON.parse(res.read).map do |data|
          Voucher.build do |v|
            v.program = data['program_name']
            v.code = data['code']
            v.valid_from = Date.parse(data['start_date'])
            v.expires_at = Date.parse(data['end_date'])
            v.summary = data['description']
            v.payload = data
          end
        end
      end

    end
  end
end
