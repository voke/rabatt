require 'base64'
require 'hmac-sha1'
require 'open-uri'
require 'json'

# DOC: https://developer.zanox.com/web/guest/publisher-api-2011

module Rabatt
  module Providers
    class Zanox < Base

      URL = 'http://api.zanox.com/json/2011-03-01'

      DEFAULT_PARAMS = {
        incentiveType: 'coupons',
        region: 'SE'
      }

      attr_accessor :connect_id, :secret_key

      def initialize(connect_id = nil, secret_key = nil)
        self.connect_id = connect_id || ENV['ZANOX_CONNECT_ID']
        self.secret_key = secret_key || ENV['ZANOX_SECRET_KEY']
      end

      def vouchers
        vouchers_by_channel(nil)
      end

      def vouchers_by_channel(adspace_id)

        http_verb = 'GET'
        resource_path = '/incentives'

        timestamp = get_timestamp
        nonce = generate_nonce
        string2sign = http_verb + resource_path + timestamp + nonce

        signature = create_signature(secret_key, string2sign)
        auth_header = "ZXWS" + " " + connect_id + ":" + signature

        endpoint = URI.parse(URL + resource_path)

        request_params = DEFAULT_PARAMS.merge(
          adspace: adspace_id
        ).reject { |k,v| v.nil? }

        endpoint.query = URI.encode_www_form(
          request_params)

        res = open(endpoint, { 'Authorization' => auth_header,
          'Date' => timestamp, 'nonce' => nonce })

        parse(res.read)

      end

      protected

      def parse(payload)
        JSON.parse(payload)['incentiveItems']['incentiveItem'].map do |data|
          Voucher.build do |v|
            v.uid = data['@id'].to_i
            v.summary = data['name']
            v.code = data['couponCode']
            v.program = data['program']['$']
            v.terms = data['info4customer']
            v.valid_from = Date.parse(data['startDate'])
            v.expires_on = Date.parse(data['endDate'])
            v.provider = :zanox
          end
        end
      end

      def generate_nonce
        Digest::MD5.hexdigest((Time.new.usec + rand()).to_s)[0..19]
      end

      def get_timestamp
        Time.now.gmtime.strftime("%a, %d %b %Y %H:%M:%S GMT").to_s
      end

      def create_signature(secret_key, string2sign)
        Base64.encode64(HMAC::SHA1.new(secret_key).update(string2sign).digest)[0..-2]
      end

    end
  end
end
