module Hog
  class Field
    attr_reader :opts

    def initialize(type, name, opts={})
      @name = name
      @type = type
      @opts = opts
      opts[:path] ||= name.to_s
    end

    def get(hash)
      val = nil
      if opts[:value]
        val = opts[:value]
      elsif opts[:json]
        lkval = lookup(opts[:json],hash) || opts[:default]
        val = JSON.dump(lkval)
      else
        val = lookup(opts[:path], hash)
      end
      get_value(val)
    end

    def to_s
      "#{@name}:#{@type}"
    end

    private

    def get_value(val)
      # xxx optimize?
      if @type == "int" && [TrueClass, FalseClass].include?(val.class)
        val ? 1 : 0
      elsif @type == "chararray"
        val.to_s
      else
        val
      end
    end

    def lookup(path, hash)
      begin
      path.split('.').inject(hash) {|acc, value| acc[value]}
      rescue
        return opts[:with_nil] if opts[:with_nil]
        raise "No path: #{path} in hash: #{hash}"
      end
    end
  end
end

