require 'spec_helper'

describe Rabatt::Providers::Adrecord do

  before do
    stub_request(:get, /.*adrecord.*/)
      .to_return(body: Fixture.read(:adrecord), status: 200)
  end

  describe '#coupons' do

    it 'returns array of vouchers' do

      provider = Rabatt::Providers::Adrecord.new
      voucher = provider.coupons(123).first

      voucher.program.must_equal 'Dunder mifflin'
      voucher.summary.must_equal "That's was she said"
      voucher.code.must_equal 'FREEPAPER'
      voucher.valid_from.must_equal Date.parse("2016-01-15")
      voucher.expires_at.must_equal Date.parse("2016-04-20")
      voucher.url.must_equal 'http://www.example.com'

    end

  end

end
