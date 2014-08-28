module Hog
  class UdfSchema
    def schema(tuple)
      "(#{@fields.map{|f| field(f) }.join(',')})"
    end

    def field(f)
      f.to_s
    end
  end
end
