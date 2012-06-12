module Configy
  class StringInquirer < String

    def method_missing( method, *args, &blk )
      if method.to_s[ -1 ] == '?'
        self == method.to_s[ 0..-2 ]
      else
        super
      end
    end
  end
end
