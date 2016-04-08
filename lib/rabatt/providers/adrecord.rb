require 'open-uri'
require 'saxerator'

module Rabatt
  module Providers
    class Adrecord < Base

      ENDPOINT = 'https://www.adrecord.com/api/discountCodes.xml?c=%d'

      def initialize
      end

      def coupons(channel_id)
        res = open(ENDPOINT % channel_id)
        parser = Saxerator.parser(res.read)
        parser.for_tag(:discountcode).map do |item|
          Voucher.new.tap do |v|
            v.program = item['program']
            v.summary = item['descriptions']
            v.code = item['code']
            v.expires_at = item['to']
            v.valid_from = item['from']
          end
        end
      end

    end
  end
end
