#
# Zanox Web Services
# http://wiki.zanox.com/en/Web_Services
#

require 'base64'
require 'hmac-sha1'
require 'open-uri'
require 'excon'
require 'json'

module Rabatt
  module Providers
    class Zanox < Base

      HOST = 'http://api.zanox.com'
      API_PATH = '/json/2011-03-01'

      DEFAULT_PARAMS = {
        incentiveType: 'coupons',
        region: 'SE'
      }

      attr_accessor :connect_id, :secret_key

      def initialize(connect_id = nil, secret_key = nil)
        self.connect_id = connect_id || ENV['ZANOX_CONNECT_ID']
        self.secret_key = secret_key || ENV['ZANOX_SECRET_KEY']
      end

      def conn
        @conn ||= Excon.new(HOST)
      end

      def coupons

        http_verb = 'GET'
        uri = '/incentives'

        timestamp = get_timestamp
        nonce = generate_nonce
        string2sign = http_verb + uri + timestamp + nonce

        signature = create_signature(secret_key, string2sign)

        # Authorization using querystring-parameters (Alternative to Authorization-Header)
        build_url = API_PATH + uri

        auth_header = "ZXWS" + " " + connect_id + ":" + signature

        res = conn.request(
          expects: [200],
          method: :get,
          path: build_url,
          query: DEFAULT_PARAMS,
          headers: { 'Authorization' => auth_header,
            'Date' => timestamp, 'nonce' => nonce }
        )

        parse(res.body)

      end

      def parse(payload)
        JSON.parse(payload)['incentiveItems']['incentiveItem'].map do |data|
          Voucher.new.tap do |v|
            v.title = data['name']
            v.summary = data['description']
            v.code = data['couponCode']
            v.program = data['program']['$']
            v.terms = data['info4customer']
            v.valid_from = data['startDate']
            v.expires_at = data['endDate']
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
