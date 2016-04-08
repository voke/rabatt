require 'json'
require 'open-uri'

# DOC: http://dev.tradedoubler.com/vouchers/publisher/

module Rabatt
  module Providers
    class Tradedoubler < Base

      ENDPOINT = 'http://api.tradedoubler.com/1.0/vouchers.json?token=%s'

      DEFAULT_PARAMS = {
        voucherTypeId: '1'
      }

      def initialize()
      end

      def epoch_to_date(value)
        Time.at(value.to_i / 1000.0).to_date
      end

      def coupons(token)
        uri = URI.parse(ENDPOINT % token)
        uri.query = URI.encode_www_form(DEFAULT_PARAMS)
        res = open(uri)
        JSON.parse(res.read).map do |data|
          Voucher.new.tap do |v|
            v.program = data['programName']
            v.code = data['code']
            v.valid_from = epoch_to_date(data['startDate'])
            v.expires_at = epoch_to_date(data['endDate'])
            v.summary = data['description']
            v.url = data['landingUrl']
          end
        end
      end

    end
  end
end
