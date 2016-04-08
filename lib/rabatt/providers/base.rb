module Rabatt
  module Providers
    class Base

      def vouchers_by_channel(*args)
        raise NotImplementedError
      end

      def vouchers
        raise NotImplementedError
      end

      def self.identifier
        self.to_s.gsub(/^.*::/, '').gsub(/(.)([A-Z])/,'\1_\2').downcase
      end

      def self.inherited(base)
        Rabatt.register(base)
      end

    end
  end
end
