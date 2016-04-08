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
      def parse_date(value)
        if !value.is_a?(Saxerator::Builder::EmptyElement)
          Date.strptime(value, DATE_FORMAT)
        end
      end
        parser = Saxerator.parser(res.read)
        parser.for_tag(:discountcode).map do |item|
          Voucher.build do |v|
            v.program = item['program']
            v.summary = item['description']
            v.code = item['code']
            v.expires_at = parse_date(item['to'])
            v.valid_from = parse_date(item['from'])
            v.url = item['url']
          end
        end
      end

    end
  end
end
