require 'spec_helper'

describe Rabatt::Providers::Zanox do

  before do
    stub_request(:get, /.*zanox.*/)
      .to_return(body: Fixture.read(:zanox), status: 200)
  end

  describe '#vouchers' do

    it 'returns array of vouchers' do

      provider = Rabatt::Providers::Zanox.new
      voucher = provider.vouchers.first

      voucher.program.must_equal 'Kwik-E-Mart'
      voucher.summary.must_equal "Oh, Calcutta!"
      voucher.code.must_equal 'COMEAGAIN'
      voucher.valid_from.must_equal Date.parse("2016-04-11")
      voucher.expires_on.must_equal Date.parse("2016-04-17")

    end

  end

end
