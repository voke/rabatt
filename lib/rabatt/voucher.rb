module Rabatt
  class Voucher

    ATTRIBUTES = %i(title code expires_at valid_from url summary terms program)
    attr_accessor *ATTRIBUTES


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
