require 'hog/pig_schema'
module Hog
  class HiveSchema < PigSchema
    XLATEMAP = {
      "chararray" => "string"
    }
    def field(f)
      "#{f.name} #{XLATEMAP[f.type] || f.type}"
    end

  end
end
