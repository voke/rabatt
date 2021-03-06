require 'spec_helper'

describe Rabatt::Voucher do

  describe '#code?' do

    it 'returns True when present' do
      voucher = Rabatt::Voucher.new
      voucher.code = 'FREESHIPPING'
      voucher.code?.must_equal true
    end

    it 'returns False when Nil' do
      voucher = Rabatt::Voucher.new
      voucher.code = nil
      voucher.code?.must_equal false
    end

    it 'returns False when blank' do
      voucher = Rabatt::Voucher.new
      voucher.code = ''
      voucher.code?.must_equal false
    end

  end

end
