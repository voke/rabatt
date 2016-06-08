require 'spec_helper'

describe Rabatt::Providers::Double do

  before do
    stub_request(:get, /.*double.*/)
      .to_return(body: Fixture.read(:double), status: 200)
  end

  describe '#vouchers_by_channel' do

    it 'returns vouchers for given channel' do
      provider = Rabatt::Providers::Double.new
      vouchers = provider.vouchers_by_channel(123)
      vouchers.size.must_equal 1
    end

  end

  describe '#vouchers' do

    it 'returns array of vouchers' do

      provider = Rabatt::Providers::Double.new
      voucher = provider.vouchers.first

      voucher.uid.must_equal 111
      voucher.program.must_equal 'Dunder mifflin'
      voucher.summary.must_equal "That's was she said"
      voucher.code.must_equal 'FREEPAPER'
      voucher.valid_from.must_equal Date.parse("2016-01-15")
      voucher.expires_on.must_equal Date.parse("2016-04-20")
      voucher.provider.must_equal :double

    end

  end

end
