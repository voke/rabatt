module Rabatt
  module Providers
    class Base

      def vouchers_by_channel(*args)
        raise NotImplementedError
      end

      def vouchers
        raise NotImplementedError
      end

    end
  end
end
