# todos
# - safe hash path lookup + provide default value?


module Hog
  class Tuple
    def initialize(name, block)
      @name = name
      @fields = []
      self.instance_eval &block
    end

    def process(hsh)
      @prepare.call(hsh)
      res = []
      @fields.each do |f|
        res << f.get(hsh)
      end
      res
    end

    def prepare(&block)
      @prepare = block
    end

    def to_s
      "(#{@fields.map{|f| f.to_s }.join(',')})"
    end

    def method_missing(meth, *args, &block)
      if [:chararray, :float, :double, :int, :long, :map].include?(meth)
        f = Field.new(meth.to_s, *args)
        @fields << f
        return f
      else
        super
      end
      end
  end
end

