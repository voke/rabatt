require 'savon'

# DOC: https://affiliate.tradetracker.com/webService

module Rabatt
  module Providers
    class Tradetracker < Base

      URL = "http://ws.tradetracker.com/soap/affiliate?wsdl"

      attr_accessor :user_id, :api_key

      def initialize(user_id = nil, api_key = nil)
        self.user_id = user_id || ENV['TRADETRACKER_USER_ID']
        self.api_key = api_key || ENV['TRADETRACKER_API_KEY']
        raise(ArgumentError, 'Missing Tradetracker ApiKey') unless self.api_key
        raise(ArgumentError, 'Missing Tradetracker UserId') unless self.user_id
      end

      def vouchers_by_channel(channel)
        get_vouchers(channel)
      end

      protected

      def client
        @client ||= Savon.client(wsdl: URL) do |global|
          global.log_level :debug
          global.log true
          global.pretty_print_xml true
        end
      end

      def auth_cookies
        @auth_cookies ||= authenticate
      end

      def authenticate
        response = client.call(:authenticate, message: {
          'customerID' => user_id,
          'passphrase' => api_key
        })
        response.http.cookies
      end

      def get_vouchers_xml(site_id)
        response = client.call(:get_material_incentive_voucher_items,
          message: { affiliateSiteID: site_id, materialOutputType: 'rss', options: {} }, cookies: auth_cookies)
        response.to_xml
      end

      def get_vouchers(site_id)
        parser = Saxerator.parser(get_vouchers_xml(site_id))
        parser.for_tag(:item).map do |data|
          Voucher.build do |v|
            v.uid = data['ID'].to_i
            v.program = data['campaign']['name']
            v.code = data['voucherCode']
            v.valid_from = Date.parse(data['validFromDate'])
            v.expires_on = Date.parse(data['validToDate'])
            v.summary = data['description']
            v.url = data['campaign']['URL']
            v.provider = :tradetracker
          end
        end
      end

    end
  end
end
