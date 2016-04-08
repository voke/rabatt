require 'json'
require 'open-uri'

# DOC: http://dev.tradedoubler.com/vouchers/publisher/

module Rabatt
  module Providers
    class Tradedoubler < Base

      ENDPOINT = 'http://api.tradedoubler.com/1.0/vouchers.json?token=%s'

      def initialize()
      end

      def coupons(token)
        res = open(ENDPOINT % token)
        JSON.parse(res.read).map do |data|
          Voucher.new.tap do |v|
            v.program = data['programName']
            v.code = data['code']
            v.valid_from = data['startDate']
            v.expires_at = data['endDate']
            v.summary = data['description']
            v.url = data['landingUrl']
          end
        end
      end

    end
  end
end
