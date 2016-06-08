require 'spec_helper'

describe Rabatt::Providers::Webgains do

  before do
    stub_request(:get, /.*webgains.*/)
      .to_return(body: Fixture.read(:webgains), status: 200)
  end

  describe '#vouchers' do

    it 'returns array of vouchers' do

      provider = Rabatt::Providers::Webgains.new
      voucher = provider.vouchers.first

      voucher.uid.must_equal 123456
      voucher.program.must_equal 'Dunder mifflin'
      voucher.summary.must_equal "That's was she said"
      voucher.code.must_equal 'FREEPAPER'
      voucher.valid_from.must_equal Date.parse("2016-06-06")
      voucher.expires_on.must_equal Date.parse("2016-06-30")
      voucher.url.must_equal 'http://eu.example.com/'
      voucher.provider.must_equal :webgains

    end

  end

end
