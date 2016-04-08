require 'spec_helper'

describe Rabatt::Providers::Tradedoubler do

  before do
    stub_request(:get, /.*tradedoubler.*/)
      .to_return(body: Fixture.read(:tradedoubler), status: 200)
  end

  describe '#coupons' do

    it 'returns array of vouchers' do

      provider = Rabatt::Providers::Tradedoubler.new
      voucher = provider.coupons('<token>').first

      voucher.program.must_equal 'Dunder mifflin'
      voucher.summary.must_equal "That's was she said"
      voucher.code.must_equal 'FREEPAPER'
      voucher.valid_from.must_equal Date.parse("2016-01-21")
      voucher.expires_at.must_equal Date.parse("2016-06-01")
      voucher.url.must_equal 'http://www.example.com/campaign'

    end

  end

end