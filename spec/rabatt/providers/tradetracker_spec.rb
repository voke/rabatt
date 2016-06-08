require 'spec_helper'

describe Rabatt::Providers::Tradetracker do

  before do
  end

  describe '#vouchers' do

    it 'returns array of vouchers' do

      provider = Rabatt::Providers::Tradetracker.new

      # Stub method instead of request to avoid all SOAP requests
      provider.expects(:get_vouchers_xml).returns(Fixture.read(:tradetracker))

      voucher = provider.vouchers_by_channel('<token>').first

      voucher.program.must_equal 'dunder-mifflin.com'
      voucher.summary.must_equal "This code gives 10% discount on all products"
      voucher.code.must_equal 'FREEPAPER'
      voucher.valid_from.must_equal Date.parse("2016-04-18")
      voucher.expires_on.must_equal Date.parse("2016-07-18")
      voucher.url.must_equal 'http://www.example.com/campaign'
      voucher.provider.must_equal :tradetracker

    end

  end

end
