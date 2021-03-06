module Rabatt
  class Voucher

    ATTRIBUTES = %i(uid provider code expires_on valid_from url summary terms program)

    attr_accessor *ATTRIBUTES
    attr_accessor :payload

    def self.build(&block)
      new.tap(&block)
    end

    def code?
      !!code && !code.empty?
    end

    def attributes
      Hash[ATTRIBUTES.map { |key| [key, send(key)] }]
    end

    def inspect
      "#<#{self.class.name} #{inspect_attributes.join(', ')}>"
    end

    def inspect_attributes
      attributes.map do |name, value|
        "#{name}: #{value.inspect}"
      end
    end

  end
end
