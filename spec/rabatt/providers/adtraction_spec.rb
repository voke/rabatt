require 'spec_helper'

describe Rabatt::Providers::Adtraction do

  before do
    stub_request(:post, /.*adtraction.*/)
      .to_return(body: Fixture.read(:adtraction), status: 200)
  end

  describe '#vouchers' do

    it 'returns array of vouchers' do

      provider = Rabatt::Providers::Adtraction.new
      voucher = provider.vouchers.last

      voucher.program.must_equal 'Kwik-E-Mart'
      voucher.summary.must_equal "Oh, Calcutta!"
      voucher.code.must_equal 'COMEAGAIN'
      voucher.valid_from.must_equal Date.parse("2016-03-30")
      voucher.expires_on.must_equal Date.parse("2016-04-14")
      voucher.provider.must_equal :adtraction

    end

  end

end
