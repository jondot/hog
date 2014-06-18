module Hog
  module Utils
    def explode(hsh, path, into_path)
      arr = hsh.delete(path)
      exploded = []
      arr.each do |item|
        exploded << ({ into_path => item }.merge(hsh))
      end
      exploded
    end
  end
end
