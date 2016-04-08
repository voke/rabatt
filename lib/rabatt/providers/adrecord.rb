require 'open-uri'
require 'saxerator'

module Rabatt
  module Providers
    class Adrecord < Base

      URL = 'https://www.adrecord.com/api/discountCodes.xml?c=%s'
      DATE_FORMAT = '%Y-%m-%d'

      def vouchers
        vouchers_by_channel(nil)
      end

      def vouchers_by_channel(channel_id)
        res = open(URL % channel_id.to_s)
        parser = Saxerator.parser(res.read)
        parser.for_tag(:discountcode).map do |item|
          Voucher.build do |v|
            v.program = item['program']
            v.summary = item['description']
            v.code = item['code']
            v.expires_on = parse_date(item['to'])
            v.valid_from = parse_date(item['from'])
            v.url = item['url']
          end
        end
      end

      protected

      def parse_date(value)
        if !value.is_a?(Saxerator::Builder::EmptyElement)
          Date.strptime(value, DATE_FORMAT)
        end
      end

    end
  end
end
