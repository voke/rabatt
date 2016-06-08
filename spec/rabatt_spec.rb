require 'spec_helper'

describe Rabatt do

  describe '.providers' do

    it 'returns Hash of providers' do
      expected_providers = %w(adtraction double adrecord tradedoubler
      zanox tradetracker webgains)
      Rabatt.providers.keys.must_equal(expected_providers)
    end

  end

  describe '.instantiate_provider' do

    it 'returns new instance of provider' do
      Rabatt.instantiate_provider(:adrecord).must_be_instance_of(Rabatt::Providers::Adrecord)
    end

    it 'raises error for invalid provider' do
      proc do
        Rabatt.instantiate_provider(:nothing)
      end.must_raise Rabatt::MissingProviderError
    end

  end

end
