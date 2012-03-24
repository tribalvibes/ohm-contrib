require "iconv"
module Ohm
  module Slug
    def self.included(base)
      base.extend FinderOverride
    end

    module FinderOverride
      def [](id)
        super(id.to_i)
      end
    end

    def slug(str = to_s)
      ret = iconv(str)
      ret.gsub!("'", "")
      ret.gsub!(/\p{^Alnum}/u, " ")
      ret.strip!
      ret.gsub!(/\s+/, "-")
      ret << "-" if ret =~ /^-*\d+$/
      ret.downcase
    end
    module_function :slug
    
    def is_slug?(s = to_s)
      s =~ /^[-\p{Alnum}]+$/ && !(s =~ /^-*\d+$/)
    end
    module_function :is_slug?

    def iconv(str)
      Iconv.iconv("ascii//translit//ignore", "utf-8", str)[0] rescue str
    end
    module_function :iconv

    def to_param
      "#{ id }-#{ slug }"
    end
  end
end